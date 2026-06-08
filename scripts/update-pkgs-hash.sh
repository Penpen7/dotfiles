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

  local base32 new_hash
  base32=$(nix-prefetch-url --unpack --type sha256 \
    "https://github.com/${owner}/${repo}/archive/${new_rev}.tar.gz" 2>/dev/null)
  new_hash=$(sri_from_base32 "$base32")

  sed -i '' "s|rev = \"[^\"]*\"|rev = \"${new_rev}\"|" "$file"
  sed -i '' "s|version = \"unstable-[^\"]*\"|version = \"unstable-${new_date}\"|" "$file"
  write_hash "$file" "$new_hash"
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
  local npm_updated=false github_updated=false

  for file in "$PKGS_DIR"/*.nix; do
    local name
    name="$(basename "$file")"

    if [[ "$name" == "default.nix" ]]; then
      continue
    fi

    if [[ "$name" == "brave.nix" ]]; then
      echo "brave:"
      update_brave "$file"
    elif grep -q 'registry.npmjs.org' "$file"; then
      echo "npm: $name"
      update_npm "$file"
      npm_updated=true
    elif grep -q 'fetchFromGitHub' "$file"; then
      echo "github: $name"
      update_fetchFromGitHub "$file"
      if grep -q 'npmDepsHash' "$file"; then
        github_updated=true
      fi
    else
      echo "warn: $name has no recognized fetch source; skipping" >&2
    fi
  done

  echo ""
  echo "Done."

  if $github_updated; then
    echo ""
    echo "Note: npmDepsHash in takt.nix was NOT updated. Manual steps:"
    echo "  1. nix build .#takt  (fails; reveals the store path)"
    echo "  2. nix run nixpkgs#prefetch-npm-deps -- <store-path>/package-lock.json"
    echo "  3. copy the output hash into npmDepsHash in takt.nix"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
