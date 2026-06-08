#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGS_DIR="${PKGS_DIR:-${SCRIPT_DIR}/../pkgs}"

GITHUB_API_OPTS=(-fsSL)
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  GITHUB_API_OPTS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

validate() {
  local value="$1" pattern="$2" label="$3"
  if [[ ! "$value" =~ $pattern ]]; then
    echo "error: unexpected ${label} value: '${value}'" >&2
    exit 1
  fi
}

write_hash() {
  local file="$1" new_hash="$2"
  sed -i '' "s|hash = \"sha256-[^\"]*\"|hash = \"${new_hash}\"|" "$file"
}

sri_from_base32() {
  nix hash convert --hash-algo sha256 --to sri "$1"
}

# fetchFromGitHub: update rev to latest commit on default branch,
# version to "unstable-YYYY-MM-DD", and src hash.
#
# npmDepsHash is intentionally left untouched; see manual steps in main().
update_fetchFromGitHub() {
  local file="$1"
  local owner repo current_rev

  owner=$(grep -E '^\s+owner = ' "$file" | sed -E 's/.*owner = "([^"]*)".*/\1/')
  repo=$(grep -E '^\s+repo = ' "$file" | sed -E 's/.*repo = "([^"]*)".*/\1/')
  current_rev=$(grep -E '^\s+rev = ' "$file" | sed -E 's/.*rev = "([^"]*)".*/\1/')

  validate "$owner" '^[a-zA-Z0-9_.-]+$' "owner"
  validate "$repo"  '^[a-zA-Z0-9_.-]+$' "repo"

  local response new_rev new_date
  response=$(curl "${GITHUB_API_OPTS[@]}" \
    "https://api.github.com/repos/${owner}/${repo}/commits?per_page=1")
  new_rev=$(echo "$response" | jq -r '.[0].sha')
  new_date=$(echo "$response" | jq -r '.[0].commit.committer.date' | cut -c1-10)

  validate "$new_rev"  '^[0-9a-f]{40}$'          "git sha"
  validate "$new_date" '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' "commit date"

  if [[ "$new_rev" == "$current_rev" ]]; then
    echo "  ${owner}/${repo}: already up to date (${current_rev:0:8})"
    return
  fi

  echo "  ${owner}/${repo}: ${current_rev:0:8} -> ${new_rev:0:8} (${new_date})"

  local prefetch_out base32 store_path new_hash
  prefetch_out=$(nix-prefetch-url --print-path --unpack --type sha256 \
    "https://github.com/${owner}/${repo}/archive/${new_rev}.tar.gz" 2>/dev/null)
  base32=$(echo "$prefetch_out" | head -1)
  store_path=$(echo "$prefetch_out" | tail -1)
  new_hash=$(sri_from_base32 "$base32")

  sed -i '' "s|rev = \"[^\"]*\"|rev = \"${new_rev}\"|" "$file"
  sed -i '' "s|version = \"unstable-[^\"]*\"|version = \"unstable-${new_date}\"|" "$file"
  write_hash "$file" "$new_hash"

  if grep -q 'npmDepsHash' "$file"; then
    echo "  ${owner}/${repo}: updating npmDepsHash..."
    local npm_deps_hash
    npm_deps_hash=$(nix run nixpkgs#prefetch-npm-deps -- "${store_path}/package-lock.json" 2>/dev/null)
    validate "$npm_deps_hash" '^sha256-' "npmDepsHash"
    sed -i '' "s|npmDepsHash = \"sha256-[^\"]*\"|npmDepsHash = \"${npm_deps_hash}\"|" "$file"
  fi
}

# npm registry (fetchurl from registry.npmjs.org): update version and hash.
update_npm() {
  local file="$1"
  local pname current_version

  pname=$(grep -E '^\s+pname = ' "$file" | sed -E 's/.*pname = "([^"]*)".*/\1/')
  current_version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')

  validate "$pname" '^[a-zA-Z0-9_.-]+$' "pname"

  local new_version
  new_version=$(curl -fsSL "https://registry.npmjs.org/${pname}/latest" | jq -r '.version')

  validate "$new_version" '^[0-9]+\.[0-9]+\.[0-9]+' "npm version"

  if [[ "$new_version" == "$current_version" ]]; then
    echo "  ${pname}: already up to date (${current_version})"
    return
  fi

  echo "  ${pname}: ${current_version} -> ${new_version}"

  local url_template new_url
  url_template=$(grep -E '^\s+url = ' "$file" | sed -E 's/.*url = "([^"]*)".*/\1/')
  new_url=$(echo "$url_template" \
    | sed "s/\${version}/${new_version}/g" \
    | sed "s/\${pname}/${pname}/g")

  local base32 new_hash
  base32=$(nix-prefetch-url --type sha256 "$new_url" 2>/dev/null)
  new_hash=$(sri_from_base32 "$base32")

  sed -i '' "s|version = \"${current_version}\"|version = \"${new_version}\"|" "$file"
  write_hash "$file" "$new_hash"
}

update_chrome() {
  local file="$1"

  local current_version latest_version
  current_version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')
  latest_version=$(curl -fsSL \
    "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=endtime=none,fraction%3E=0.5&order_by=version%20desc" \
    | jq -r '.releases[0].version')

  validate "$latest_version" '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' "chrome version"

  if [[ "$latest_version" == "$current_version" ]]; then
    echo "  chrome: ${current_version} (latest, re-fetching hash)"
  else
    echo "  chrome: ${current_version} -> ${latest_version}"
  fi

  local uuid response url_base pkg_name
  uuid=$(python3 -c "import uuid; print(str(uuid.uuid4()).upper())")
  response=$(curl -fsSL -X POST -H "Content-Type: text/xml" \
    --data "<?xml version='1.0' encoding='UTF-8'?>
<request protocol='3.0' version='1.3.23.9' shell_version='1.3.21.103' ismachine='1'
    sessionid='${uuid}' installsource='ondemandcheckforupdate'
    requestid='${uuid}' dedup='cr'>
    <hw sse='1' sse2='1' sse3='1' ssse3='1' sse41='1' sse42='1' avx='1' physmemory='12582912' />
    <os platform='mac' version='${latest_version}' arch='arm64'/>
    <app appid='com.google.Chrome' ap=' ' version=' ' nextversion=' ' lang=' ' brand='GGLS' client=' '>
        <updatecheck/>
    </app>
</request>" "https://tools.google.com/service/update2")

  url_base=$(echo "$response" | python3 -c "
import sys, xml.etree.ElementTree as ET
root = ET.fromstring(sys.stdin.read())
for u in root.findall('.//url'):
    cb = u.get('codebase', '')
    if cb.startswith('https://dl.google.com/release2'):
        print(cb); break
")
  pkg_name=$(echo "$response" | python3 -c "
import sys, xml.etree.ElementTree as ET
root = ET.fromstring(sys.stdin.read())
for p in root.findall('.//package'):
    print(p.get('name', '')); break
")

  validate "$url_base" '^https://dl\.google\.com/release2/chrome/' "chrome url base"
  validate "$pkg_name" '^GoogleChrome-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\.dmg$' "chrome pkg name"

  local download_url="${url_base}${pkg_name}"
  local new_hash
  new_hash=$(nix store prefetch-file --hash-type sha256 --json "$download_url" | jq -r '.hash')

  cat > "$file" << EOF
{ pkgs }:
let
  version = "${latest_version}";
  url = "${download_url}";
  hash = "${new_hash}";
in
pkgs.google-chrome.overrideAttrs (_: {
  inherit version;
  src = pkgs.fetchurl { inherit url hash; };
})
EOF
}

update_brave() {
  local file="$1"

  local current_version latest_version
  current_version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')
  latest_version=$(curl "${GITHUB_API_OPTS[@]}" \
    "https://api.github.com/repos/brave/brave-browser/releases/latest" \
    | jq -r '.tag_name' | sed 's/^v//')

  validate "$latest_version" '^[0-9]+\.[0-9]+\.[0-9]+' "brave version"

  if [[ "$latest_version" == "$current_version" ]]; then
    echo "  brave: ${current_version} (latest, re-fetching hashes)"
  else
    echo "  brave: ${current_version} -> ${latest_version}"
  fi

  local hash_arm64 hash_x64
  hash_arm64=$(nix store prefetch-file --hash-type sha256 --json \
    "https://github.com/brave/brave-browser/releases/download/v${latest_version}/brave-v${latest_version}-darwin-arm64.zip" \
    | jq -r '.hash')
  hash_x64=$(nix store prefetch-file --hash-type sha256 --json \
    "https://github.com/brave/brave-browser/releases/download/v${latest_version}/brave-v${latest_version}-darwin-x64.zip" \
    | jq -r '.hash')

  cat > "$file" << EOF
{ pkgs }:
let
  version = "${latest_version}";
  archives = {
    aarch64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v\${version}/brave-v\${version}-darwin-arm64.zip";
      hash = "${hash_arm64}";
    };
    x86_64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v\${version}/brave-v\${version}-darwin-x64.zip";
      hash = "${hash_x64}";
    };
  };
  archive = archives.\${pkgs.stdenv.hostPlatform.system};
in
pkgs.brave.overrideAttrs (_: {
  inherit version;
  src = pkgs.fetchurl archive;
})
EOF
}

main() {
  local npm_updated=false

  for file in "$PKGS_DIR"/*.nix; do
    local name
    name="$(basename "$file")"

    if [[ "$name" == "default.nix" ]]; then
      continue
    fi

    if [[ "$name" == "brave.nix" ]]; then
      echo "brave:"
      update_brave "$file"
    elif [[ "$name" == "chrome.nix" ]]; then
      echo "chrome:"
      update_chrome "$file"
    elif grep -q 'registry.npmjs.org' "$file"; then
      echo "npm: $name"
      update_npm "$file"
      npm_updated=true
    elif grep -q 'fetchFromGitHub' "$file"; then
      echo "github: $name"
      update_fetchFromGitHub "$file"
    else
      echo "warn: $name has no recognized fetch source; skipping" >&2
    fi
  done

  echo ""
  echo "Done."

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
