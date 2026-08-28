#!/usr/bin/env bash
# Tests for scripts/update-pkgs-hash.sh
#
# Usage: bash scripts/update-pkgs-hash.test.sh
#
# Nothing here touches the network or the nix store: curl, nix-prefetch-url and
# nix are replaced by stubs on PATH that return fixed, recognisable values and
# record their invocations. Every production function is called inside a command
# substitution (its own subshell) because the script's validate() aborts with
# `exit 1`, which would otherwise tear down the whole harness.
#
# Test scope:
#   Unit        - sed_i, write_hash, write_hash_in_block, validate
#   Function    - update_fetchFromGitHub, update_npm, update_github_releases,
#                 update_pnpm_pkg
#   Integration - main() dispatch over a temp pkgs/ directory

set -uo pipefail

PASS=0
FAIL=0

# ---------- minimal test framework ----------

ok()   { echo "  ok:   $1"; PASS=$((PASS+1)); }
fail() {
    local msg="$1" exp="${2:-}" got="${3:-}"
    echo "  FAIL: $msg"
    [[ -n "$exp" ]] && echo "        expected: $exp"
    [[ -n "$got" ]] && echo "        actual:   $got"
    FAIL=$((FAIL+1))
}

assert_eq() {
    local exp="$1" got="$2" msg="$3"
    [[ "$exp" == "$got" ]] && ok "$msg" || fail "$msg" "$exp" "$got"
}

assert_contains() {
    local pattern="$1" str="$2" msg="$3"
    printf '%s\n' "$str" | grep -q -e "$pattern" && ok "$msg" \
        || fail "$msg" "(pattern: $pattern)" "$str"
}

assert_not_contains() {
    local pattern="$1" str="$2" msg="$3"
    printf '%s\n' "$str" | grep -q -e "$pattern" \
        && fail "$msg" "(should not match: $pattern)" "$str" \
        || ok "$msg"
}

assert_file_contains() {
    local pattern="$1" file="$2" msg="$3"
    grep -q -e "$pattern" "$file" && ok "$msg" \
        || fail "$msg" "(pattern: $pattern)" "$(cat "$file")"
}

assert_file_not_contains() {
    local pattern="$1" file="$2" msg="$3"
    grep -q -e "$pattern" "$file" \
        && fail "$msg" "(should not match: $pattern)" "$(cat "$file")" \
        || ok "$msg"
}

# Run a production function in a subshell; capture combined output + status.
# LAST_OUT / LAST_STATUS are readable afterwards.
run_fn() {
    LAST_OUT=$("$@" 2>&1)
    LAST_STATUS=$?
}

assert_ok_status() {
    local msg="$1"
    [[ "$LAST_STATUS" -eq 0 ]] && ok "$msg" \
        || fail "$msg" "exit 0" "exit ${LAST_STATUS}: ${LAST_OUT}"
}

assert_error_status() {
    local msg="$1"
    [[ "$LAST_STATUS" -ne 0 ]] && ok "$msg" \
        || fail "$msg" "non-zero exit" "exit 0: ${LAST_OUT}"
}

# ---------- preflight ----------

for tool in jq awk sed grep; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "error: '$tool' is required to run these tests" >&2
        exit 1
    }
done

SCRIPT_DIR_TEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR_TEST/update-pkgs-hash.sh"

[[ -f "$SCRIPT_PATH" ]] || {
    echo "error: ${SCRIPT_PATH} not found" >&2
    exit 1
}

TMP=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '$TMP'" EXIT

# ---------- stub values ----------
# Exported so the stubs (separate processes) and the assertions agree on them.

export MOCK_STATE="$TMP/state"
mkdir -p "$MOCK_STATE"

export MOCK_REV="0123456789abcdef0123456789abcdef01234567"
export MOCK_COMMIT_DATE="2026-08-01"
export MOCK_VERSION="9.9.9"

# Distinct per-source hashes so a hash landing in the wrong field is visible.
export SRI_GITHUB_ARCHIVE="sha256-MOCKGITHUBARCHIVE="
export SRI_NPM_TARBALL="sha256-MOCKNPMTARBALL="
export SRI_GENERIC="sha256-MOCKGENERIC="
export SRI_NPM_DEPS="sha256-MOCKNPMDEPS="
export SRI_PNPM_DEPS="sha256-MOCKPNPMDEPS="

# Per-asset sha256 hex digests served by the SHASUMS256.txt stub.
SHA_MACOS_ARM64=$(printf 'a%.0s' {1..64})
SHA_MACOS_X64=$(printf 'b%.0s' {1..64})
SHA_LINUX_X64=$(printf 'd%.0s' {1..64})
SHA_TAR_XZ_DECOY=$(printf 'e%.0s' {1..64})

# A plausible store path for `nix-prefetch-url --print-path`.
export MOCK_STORE_PATH="$TMP/store/source"
mkdir -p "$MOCK_STORE_PATH"
echo '{}' > "$MOCK_STORE_PATH/package-lock.json"

# ---------- stubs ----------

MOCK_BIN="$TMP/bin"
mkdir -p "$MOCK_BIN"

# curl: serves the four endpoints the script calls. Any other URL is a hard
# error so an unmocked network call can never silently pass.
cat > "$MOCK_BIN/curl" << 'STUB'
#!/usr/bin/env bash
url="${!#}"
echo "$url" >> "$MOCK_STATE/curl.calls"
case "$url" in
  *api.github.com/repos/*/commits*)
    printf '[{"sha":"%s","commit":{"committer":{"date":"%sT09:12:33Z"}}}]' \
      "$MOCK_REV" "$MOCK_COMMIT_DATE"
    ;;
  *api.github.com/repos/*/releases/latest)
    printf '{"tag_name":"v%s"}' "$MOCK_VERSION"
    ;;
  *registry.npmjs.org/*/latest)
    printf '{"version":"%s"}' "$MOCK_VERSION"
    ;;
  *releases/download/*/SHASUMS256.txt)
    # .../<owner>/<repo>/releases/download/v<ver>/SHASUMS256.txt
    repo=$(echo "$url" | sed -E 's#.*github.com/[^/]+/([^/]+)/releases.*#\1#')
    ver=$(echo "$url" | sed -E 's#.*/releases/download/v([^/]+)/.*#\1#')
    a=$(printf 'a%.0s' {1..64})
    b=$(printf 'b%.0s' {1..64})
    d=$(printf 'd%.0s' {1..64})
    e=$(printf 'e%.0s' {1..64})
    printf '%s  ./%s-v%s-%s\n' \
      "$a" "$repo" "$ver" "macos-arm64.tar.gz" \
      "$b" "$repo" "$ver" "macos-x64.tar.gz" \
      "$d" "$repo" "$ver" "linux-x64.tar.gz" \
      "$e" "$repo" "$ver" "macos-arm64.tar.xz"
    ;;
  *)
    echo "stub curl: unexpected url: $url" >&2
    exit 22
    ;;
esac
STUB
chmod +x "$MOCK_BIN/curl"

# nix-prefetch-url: records its full argv and returns a base32 hash tagged by
# the kind of URL requested, so `nix hash convert` can map it back to a
# distinct SRI hash. With --print-path it also prints the store path.
cat > "$MOCK_BIN/nix-prefetch-url" << 'STUB'
#!/usr/bin/env bash
url="${!#}"
echo "$*" >> "$MOCK_STATE/prefetch.calls"
case "$url" in
  *registry.npmjs.org*)     printf 'mockbase32npmtarball\n' ;;
  *github.com/*/archive/*)  printf 'mockbase32githubarchive\n' ;;
  *)                        printf 'mockbase32generic\n' ;;
esac
for arg in "$@"; do
  [[ "$arg" == "--print-path" ]] && printf '%s\n' "$MOCK_STORE_PATH"
done
exit 0
STUB
chmod +x "$MOCK_BIN/nix-prefetch-url"

# nix: covers the three subcommands the script uses.
#   hash convert  -> map the tagged base32 back to an SRI hash
#   run           -> prefetch-npm-deps
#   build         -> the fixed-output mismatch that yields the pnpmDeps hash
cat > "$MOCK_BIN/nix" << 'STUB'
#!/usr/bin/env bash
echo "$*" >> "$MOCK_STATE/nix.calls"
case "${1:-}" in
  hash)
    case "${!#}" in
      *npmtarball*)     printf '%s\n' "$SRI_NPM_TARBALL" ;;
      *githubarchive*)  printf '%s\n' "$SRI_GITHUB_ARCHIVE" ;;
      *)                printf '%s\n' "$SRI_GENERIC" ;;
    esac
    ;;
  run)
    printf '%s\n' "$SRI_NPM_DEPS"
    ;;
  build)
    printf 'error: hash mismatch in fixed-output derivation\n' >&2
    printf '  specified: %s\n' "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" >&2
    printf '  got:    %s\n' "$SRI_PNPM_DEPS" >&2
    exit 1
    ;;
  *)
    echo "stub nix: unexpected subcommand: $*" >&2
    exit 1
    ;;
esac
STUB
chmod +x "$MOCK_BIN/nix"

export PATH="$MOCK_BIN:$PATH"
# Keep curl's argv deterministic regardless of the ambient environment.
unset GITHUB_TOKEN

# ---------- fixtures ----------

# fetchFromGitHub only.
fixture_github() {
    cat > "$1" << 'NIX'
{ pkgs }:
pkgs.tmuxPlugins.battery.overrideAttrs (_: {
  version = "unstable-2025-12-30";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-battery";
    rev = "43832651ede43f54dcf0588727c1957fe648d57d";
    hash = "sha256-OLDGITHUBHASH=";
  };
})
NIX
}

# fetchFromGitHub whose rev already equals the latest upstream commit.
fixture_github_up_to_date() {
    cat > "$1" << NIX
{ pkgs }:
pkgs.tmuxPlugins.battery.overrideAttrs (_: {
  version = "unstable-2025-12-30";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-battery";
    rev = "${MOCK_REV}";
    hash = "sha256-OLDGITHUBHASH=";
  };
})
NIX
}

# fetchFromGitHub + buildNpmPackage npmDepsHash.
fixture_github_npm_deps() {
    cat > "$1" << 'NIX'
{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-07-28";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "146e5b3e39ebd7628e16503105e024d4c5a99d97";
    hash = "sha256-OLDGITHUBHASH=";
  };

  npmDepsHash = "sha256-OLDNPMDEPSHASH=";
}
NIX
}

# fetchurl from the npm registry (url carries a ${version} placeholder).
fixture_npm() {
    cat > "$1" << 'NIX'
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "ccstatusline";
  version = "2.2.27";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${version}.tgz";
    hash = "sha256-OLDNPMHASH=";
  };
}
NIX
}

# difit-style: fetchFromGitHub src + npm dist tarball + fetchPnpmDeps.
# Three hash fields, so each is written into its own block.
fixture_pnpm() {
    cat > "$1" << 'NIX'
{ pkgs }:
let
  pnpm = pkgs.pnpm_11.override { nodejs = pkgs.nodejs_22; };
  version = "5.0.8";
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "yoshiko-pg";
    repo = "difit";
    tag = "v${version}";
    hash = "sha256-OLDSRCHASH=";
  };

  distSrc = pkgs.fetchurl {
    url = "https://registry.npmjs.org/difit/-/difit-${version}.tgz";
    hash = "sha256-OLDDISTHASH=";
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-OLDPNPMHASH=";
  };
})
NIX
}

# GitHub Releases prebuilt binaries, checksums from SHASUMS256.txt.
fixture_releases() {
    cat > "$1" << 'NIX'
{ pkgs }:
let
  version = "1.0.0";
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "0000000000000000000000000000000000000000000000000000000000000000";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "1111111111111111111111111111111111111111111111111111111111111111";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "2222222222222222222222222222222222222222222222222222222222222222";
      };
    }
    .${pkgs.stdenv.hostPlatform.system};
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "mise";
  inherit version;
  src = pkgs.fetchurl {
    url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-${plat.asset}.tar.gz";
    inherit (plat) sha256;
  };
}
NIX
}

# No fetchFromGitHub / fetchurl-from-npm / releases URL: main() must warn+skip.
fixture_unrecognized() {
    cat > "$1" << 'NIX'
{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "tableplus";
  version = "662";
  src = pkgs.fetchurl {
    url = "https://files.tableplus.com/macos/662/TablePlus.dmg";
    hash = "sha256-TABLEPLUS=";
  };
}
NIX
}

# Skipped by name.
fixture_default() {
    cat > "$1" << 'NIX'
{
  overlays.default = final: prev: {
    takt = import ./takt.nix { pkgs = final; };
  };
}
NIX
}

create_pkgs_fixtures() {
    local dir="$1"
    mkdir -p "$dir"
    fixture_github          "$dir/tmux-plugin-battery.nix"
    fixture_github_npm_deps "$dir/takt.nix"
    fixture_npm             "$dir/ccstatusline.nix"
    fixture_pnpm            "$dir/difit.nix"
    fixture_releases        "$dir/mise.nix"
    fixture_unrecognized    "$dir/tableplus.nix"
    fixture_default         "$dir/default.nix"
}

# ---------- load the production script ----------

# Point PKGS_DIR at a scratch directory before sourcing so that an accidental
# main() call can never touch the real pkgs/ tree.
export PKGS_DIR="$TMP/unused-pkgs"
mkdir -p "$PKGS_DIR"

# The script guards its main execution with
#   [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
# so sourcing only defines functions.
# shellcheck source=/dev/null
source "$SCRIPT_PATH"
# Sourcing leaks `set -e` from the production script into this harness, which
# would abort the suite on the first failing assertion. Restore no-errexit.
set +e

# ==============================================================
# [Unit] sed_i
# ==============================================================
echo ""
echo "=== [Unit] sed_i ==="

test_sed_i_edits_in_place() {
    local file="$TMP/sed_i_basic.txt"
    printf 'hash = "sha256-OLD="\n' > "$file"
    run_fn sed_i 's|sha256-OLD=|sha256-NEW=|' "$file"
    assert_ok_status "sed_i exits 0"
    assert_file_contains 'sha256-NEW=' "$file" "sed_i rewrites the file in place"
}
test_sed_i_edits_in_place

test_sed_i_leaves_no_temp_file() {
    local file="$TMP/sed_i_tmp.txt"
    printf 'version = "1.0.0"\n' > "$file"
    run_fn sed_i 's|1.0.0|2.0.0|' "$file"
    [[ ! -e "${file}.tmp" ]] && ok "sed_i leaves no .tmp leftover" \
        || fail "sed_i leaves no .tmp leftover" "no ${file}.tmp" "${file}.tmp exists"
}
test_sed_i_leaves_no_temp_file

# ==============================================================
# [Unit] write_hash
# ==============================================================
echo ""
echo "=== [Unit] write_hash ==="

test_write_hash_replaces_single_hash() {
    local file="$TMP/write_hash_single.nix"
    fixture_github "$file"
    run_fn write_hash "$file" "sha256-NEWHASH="
    assert_ok_status "write_hash exits 0 on a single-hash file"
    assert_file_contains 'sha256-NEWHASH=' "$file" "write_hash writes the new SRI hash"
    assert_file_not_contains 'OLDGITHUBHASH' "$file" "write_hash removes the old hash"
}
test_write_hash_replaces_single_hash

test_write_hash_preserves_npm_deps_hash() {
    local file="$TMP/write_hash_npm.nix"
    fixture_github_npm_deps "$file"
    run_fn write_hash "$file" "sha256-NEWHASH="
    assert_ok_status "write_hash exits 0 when npmDepsHash is also present"
    assert_file_contains 'npmDepsHash = "sha256-OLDNPMDEPSHASH="' "$file" \
        "write_hash does not match the npmDepsHash field"
    assert_file_contains 'hash = "sha256-NEWHASH="' "$file" \
        "write_hash still updates the src hash field"
}
test_write_hash_preserves_npm_deps_hash

test_write_hash_rejects_multi_hash_file() {
    local file="$TMP/write_hash_multi.nix"
    fixture_pnpm "$file"
    local before after
    before=$(cat "$file")
    run_fn write_hash "$file" "sha256-NEWHASH="
    after=$(cat "$file")
    assert_error_status "write_hash refuses a file with 3 hash fields"
    assert_contains 'has 3' "$LAST_OUT" "write_hash reports the offending hash count"
    assert_eq "$before" "$after" "write_hash leaves a multi-hash file untouched"
}
test_write_hash_rejects_multi_hash_file

test_write_hash_rejects_file_without_hash() {
    local file="$TMP/write_hash_none.nix"
    fixture_default "$file"
    run_fn write_hash "$file" "sha256-NEWHASH="
    assert_error_status "write_hash refuses a file with no hash field"
    assert_contains 'has 0' "$LAST_OUT" "write_hash reports a zero hash count"
}
test_write_hash_rejects_file_without_hash

# ==============================================================
# [Unit] write_hash_in_block
# ==============================================================
echo ""
echo "=== [Unit] write_hash_in_block ==="

test_write_hash_in_block_targets_named_block() {
    local file="$TMP/block.nix"
    fixture_pnpm "$file"
    run_fn write_hash_in_block "$file" 'fetchFromGitHub' "sha256-SRC="
    assert_ok_status "write_hash_in_block exits 0"
    assert_file_contains 'sha256-SRC=' "$file" \
        "write_hash_in_block writes into the fetchFromGitHub block"
    assert_file_contains 'sha256-OLDDISTHASH=' "$file" \
        "write_hash_in_block leaves the fetchurl block alone"
    assert_file_contains 'sha256-OLDPNPMHASH=' "$file" \
        "write_hash_in_block leaves the fetchPnpmDeps block alone"
}
test_write_hash_in_block_targets_named_block

test_write_hash_in_block_writes_each_block_independently() {
    local file="$TMP/block_all.nix"
    fixture_pnpm "$file"
    run_fn write_hash_in_block "$file" 'fetchFromGitHub' "sha256-SRC="
    run_fn write_hash_in_block "$file" 'fetchurl'        "sha256-DIST="
    run_fn write_hash_in_block "$file" 'fetchPnpmDeps'   "sha256-PNPM="
    assert_contains 'hash = "sha256-SRC="' \
        "$(awk '/fetchFromGitHub/,/};/' "$file")" \
        "src hash lands in the fetchFromGitHub block"
    assert_contains 'hash = "sha256-DIST="' \
        "$(awk '/fetchurl/,/};/' "$file")" \
        "dist hash lands in the fetchurl block"
    assert_contains 'hash = "sha256-PNPM="' \
        "$(awk '/fetchPnpmDeps/,/};/' "$file")" \
        "pnpmDeps hash lands in the fetchPnpmDeps block"
}
test_write_hash_in_block_writes_each_block_independently

# ==============================================================
# [Unit] validate
# ==============================================================
echo ""
echo "=== [Unit] validate ==="

test_validate_accepts_matching_value() {
    run_fn validate "$MOCK_REV" '^[0-9a-f]{40}$' "git sha"
    assert_ok_status "validate accepts a 40 char git sha"
}
test_validate_accepts_matching_value

test_validate_rejects_empty_value() {
    run_fn validate "" '^[0-9a-f]{40}$' "git sha"
    assert_error_status "validate rejects an empty git sha"
    assert_contains "unexpected git sha value" "$LAST_OUT" \
        "validate reports the label of the rejected value"
}
test_validate_rejects_empty_value

test_validate_rejects_shell_metacharacters_in_owner() {
    run_fn validate 'foo;rm -rf /' '^[a-zA-Z0-9_.-]+$' "owner"
    assert_error_status "validate rejects an owner containing shell metacharacters"
}
test_validate_rejects_shell_metacharacters_in_owner

# ==============================================================
# [Function] update_fetchFromGitHub
# ==============================================================
echo ""
echo "=== [Function] update_fetchFromGitHub ==="

test_update_fetchFromGitHub_updates_rev_version_and_hash() {
    local file="$TMP/gh_basic.nix"
    fixture_github "$file"
    run_fn update_fetchFromGitHub "$file"
    assert_ok_status "update_fetchFromGitHub exits 0"
    assert_file_contains "rev = \"${MOCK_REV}\"" "$file" \
        "update_fetchFromGitHub writes the latest commit sha"
    assert_file_contains "version = \"unstable-${MOCK_COMMIT_DATE}\"" "$file" \
        "update_fetchFromGitHub bumps version to unstable-<commit date>"
    assert_file_contains "$SRI_GITHUB_ARCHIVE" "$file" \
        "update_fetchFromGitHub writes the archive SRI hash"
}
test_update_fetchFromGitHub_updates_rev_version_and_hash

test_update_fetchFromGitHub_prefetch_flags() {
    rm -f "$MOCK_STATE/prefetch.calls"
    local file="$TMP/gh_flags.nix"
    fixture_github "$file"
    run_fn update_fetchFromGitHub "$file"
    local calls
    calls=$(cat "$MOCK_STATE/prefetch.calls" 2>/dev/null)
    # --unpack: the archive is unpacked so the hash matches fetchFromGitHub's.
    assert_contains '--unpack' "$calls" \
        "nix-prefetch-url is called with --unpack"
    # --print-path: the store path feeds prefetch-npm-deps.
    assert_contains '--print-path' "$calls" \
        "nix-prefetch-url is called with --print-path"
    assert_contains "archive/${MOCK_REV}\.tar\.gz" "$calls" \
        "nix-prefetch-url fetches the .tar.gz archive of the new rev"
}
test_update_fetchFromGitHub_prefetch_flags

test_update_fetchFromGitHub_refreshes_npm_deps_hash() {
    rm -f "$MOCK_STATE/nix.calls"
    local file="$TMP/gh_npmdeps.nix"
    fixture_github_npm_deps "$file"
    run_fn update_fetchFromGitHub "$file"
    assert_ok_status "update_fetchFromGitHub exits 0 on a buildNpmPackage file"
    assert_file_contains "npmDepsHash = \"${SRI_NPM_DEPS}\"" "$file" \
        "update_fetchFromGitHub refreshes npmDepsHash via prefetch-npm-deps"
    assert_file_contains "hash = \"${SRI_GITHUB_ARCHIVE}\"" "$file" \
        "update_fetchFromGitHub still writes the src hash"
    assert_contains 'prefetch-npm-deps' "$(cat "$MOCK_STATE/nix.calls")" \
        "prefetch-npm-deps is invoked for the npmDepsHash"
}
test_update_fetchFromGitHub_refreshes_npm_deps_hash

test_update_fetchFromGitHub_skips_npm_deps_when_absent() {
    rm -f "$MOCK_STATE/nix.calls"
    local file="$TMP/gh_nonpm.nix"
    fixture_github "$file"
    run_fn update_fetchFromGitHub "$file"
    assert_not_contains 'prefetch-npm-deps' "$(cat "$MOCK_STATE/nix.calls")" \
        "prefetch-npm-deps is not invoked when the file has no npmDepsHash"
}
test_update_fetchFromGitHub_skips_npm_deps_when_absent

test_update_fetchFromGitHub_noop_when_rev_unchanged() {
    rm -f "$MOCK_STATE/prefetch.calls"
    local file="$TMP/gh_uptodate.nix"
    fixture_github_up_to_date "$file"
    local before after
    before=$(cat "$file")
    run_fn update_fetchFromGitHub "$file"
    after=$(cat "$file")
    assert_ok_status "update_fetchFromGitHub exits 0 when already up to date"
    assert_eq "$before" "$after" "file is untouched when rev already matches upstream"
    assert_contains 'already up to date' "$LAST_OUT" \
        "update_fetchFromGitHub reports 'already up to date'"
    [[ ! -f "$MOCK_STATE/prefetch.calls" ]] && ok "no prefetch is issued when up to date" \
        || fail "no prefetch is issued when up to date" "no calls" \
                "$(cat "$MOCK_STATE/prefetch.calls")"
}
test_update_fetchFromGitHub_noop_when_rev_unchanged

# ==============================================================
# [Function] update_npm
# ==============================================================
echo ""
echo "=== [Function] update_npm ==="

test_update_npm_updates_version_and_hash() {
    local file="$TMP/npm_basic.nix"
    fixture_npm "$file"
    run_fn update_npm "$file"
    assert_ok_status "update_npm exits 0"
    assert_file_contains "version = \"${MOCK_VERSION}\"" "$file" \
        "update_npm bumps version to the latest npm release"
    assert_file_contains "$SRI_NPM_TARBALL" "$file" \
        "update_npm writes the npm tarball SRI hash"
    assert_file_not_contains 'OLDNPMHASH' "$file" "update_npm removes the old hash"
}
test_update_npm_updates_version_and_hash

test_update_npm_keeps_version_placeholder_in_url() {
    local file="$TMP/npm_url.nix"
    fixture_npm "$file"
    run_fn update_npm "$file"
    assert_file_contains 'ccstatusline-\${version}\.tgz' "$file" \
        "the url keeps its \${version} placeholder (nix interpolates it)"
}
test_update_npm_keeps_version_placeholder_in_url

test_update_npm_substitutes_version_when_prefetching() {
    rm -f "$MOCK_STATE/prefetch.calls"
    local file="$TMP/npm_prefetch.nix"
    fixture_npm "$file"
    run_fn update_npm "$file"
    local calls
    calls=$(cat "$MOCK_STATE/prefetch.calls" 2>/dev/null)
    assert_contains "ccstatusline-${MOCK_VERSION}\.tgz" "$calls" \
        "\${version} is substituted in the prefetched url"
    assert_not_contains '--unpack' "$calls" \
        "nix-prefetch-url is called WITHOUT --unpack for a plain fetchurl"
}
test_update_npm_substitutes_version_when_prefetching

test_update_npm_noop_when_version_unchanged() {
    local file="$TMP/npm_uptodate.nix"
    fixture_npm "$file"
    sed_i "s|version = \"2.2.27\"|version = \"${MOCK_VERSION}\"|" "$file"
    local before after
    before=$(cat "$file")
    run_fn update_npm "$file"
    after=$(cat "$file")
    assert_ok_status "update_npm exits 0 when already up to date"
    assert_eq "$before" "$after" "file is untouched when version already matches npm"
    assert_contains 'already up to date' "$LAST_OUT" \
        "update_npm reports 'already up to date'"
}
test_update_npm_noop_when_version_unchanged

# ==============================================================
# [Function] update_github_releases
# ==============================================================
echo ""
echo "=== [Function] update_github_releases ==="

test_update_github_releases_bumps_version() {
    local file="$TMP/rel_version.nix"
    fixture_releases "$file"
    run_fn update_github_releases "$file"
    assert_ok_status "update_github_releases exits 0"
    assert_file_contains "version = \"${MOCK_VERSION}\"" "$file" \
        "update_github_releases bumps version to the latest release tag (v stripped)"
}
test_update_github_releases_bumps_version

test_update_github_releases_updates_every_platform_hash() {
    local file="$TMP/rel_hashes.nix"
    fixture_releases "$file"
    run_fn update_github_releases "$file"
    assert_file_contains "$SHA_MACOS_ARM64" "$file" \
        "macos-arm64 sha256 comes from SHASUMS256.txt"
    assert_file_contains "$SHA_MACOS_X64" "$file" \
        "macos-x64 sha256 comes from SHASUMS256.txt"
    assert_file_contains "$SHA_LINUX_X64" "$file" \
        "linux-x64 sha256 comes from SHASUMS256.txt"
    assert_file_not_contains '0000000000000000' "$file" "stale macos-arm64 sha256 is replaced"
    assert_file_not_contains '1111111111111111' "$file" "stale macos-x64 sha256 is replaced"
    assert_file_not_contains '2222222222222222' "$file" "stale linux-x64 sha256 is replaced"
}
test_update_github_releases_updates_every_platform_hash

test_update_github_releases_ignores_non_tar_gz_assets() {
    local file="$TMP/rel_targz.nix"
    fixture_releases "$file"
    run_fn update_github_releases "$file"
    assert_file_not_contains "$SHA_TAR_XZ_DECOY" "$file" \
        "the .tar.xz checksum is never selected (asset filename must match exactly)"
}
test_update_github_releases_ignores_non_tar_gz_assets

test_update_github_releases_errors_on_missing_asset() {
    local file="$TMP/rel_missing.nix"
    fixture_releases "$file"
    # An asset that SHASUMS256.txt does not list must abort rather than write
    # an empty sha256.
    sed_i 's|asset = "linux-x64"|asset = "solaris-sparc"|' "$file"
    run_fn update_github_releases "$file"
    assert_error_status "update_github_releases aborts when an asset is missing from SHASUMS256.txt"
    assert_contains 'unexpected solaris-sparc sha256 value' "$LAST_OUT" \
        "the error names the asset whose checksum was not found"
}
test_update_github_releases_errors_on_missing_asset

# ==============================================================
# [Function] update_pnpm_pkg
# ==============================================================
echo ""
echo "=== [Function] update_pnpm_pkg ==="

test_update_pnpm_pkg_updates_version_and_all_three_hashes() {
    local file="$TMP/pnpm_all.nix"
    fixture_pnpm "$file"
    run_fn update_pnpm_pkg "$file"
    assert_ok_status "update_pnpm_pkg exits 0"
    assert_file_contains "version = \"${MOCK_VERSION}\"" "$file" \
        "update_pnpm_pkg bumps version to the latest npm release"
    assert_contains "hash = \"${SRI_GITHUB_ARCHIVE}\"" \
        "$(awk '/fetchFromGitHub/,/};/' "$file")" \
        "src hash is written into the fetchFromGitHub block"
    assert_contains "hash = \"${SRI_NPM_TARBALL}\"" \
        "$(awk '/fetchurl/,/};/' "$file")" \
        "dist hash is written into the fetchurl block"
    assert_contains "hash = \"${SRI_PNPM_DEPS}\"" \
        "$(awk '/fetchPnpmDeps/,/};/' "$file")" \
        "pnpmDeps hash is parsed from the build mismatch and written into its block"
}
test_update_pnpm_pkg_updates_version_and_all_three_hashes

test_update_pnpm_pkg_leaves_no_fake_hash_behind() {
    local file="$TMP/pnpm_fake.nix"
    fixture_pnpm "$file"
    run_fn update_pnpm_pkg "$file"
    assert_file_not_contains "$FAKE_HASH" "$file" \
        "the placeholder hash used to trigger the build is overwritten"
}
test_update_pnpm_pkg_leaves_no_fake_hash_behind

test_update_pnpm_pkg_fetches_the_version_tag_archive() {
    rm -f "$MOCK_STATE/prefetch.calls"
    local file="$TMP/pnpm_urls.nix"
    fixture_pnpm "$file"
    run_fn update_pnpm_pkg "$file"
    local calls
    calls=$(cat "$MOCK_STATE/prefetch.calls" 2>/dev/null)
    assert_contains "archive/refs/tags/v${MOCK_VERSION}\.tar\.gz" "$calls" \
        "src is prefetched from the v<version> tag archive"
    assert_contains "difit-${MOCK_VERSION}\.tgz" "$calls" \
        "dist is prefetched from the npm registry tarball"
}
test_update_pnpm_pkg_fetches_the_version_tag_archive

# ==============================================================
# [Integration] full script run: main() dispatch
# ==============================================================
echo ""
echo "=== [Integration] full script run ==="

INT_PKGS="$TMP/int_pkgs"
create_pkgs_fixtures "$INT_PKGS"
DEFAULT_BEFORE=$(cat "$INT_PKGS/default.nix")
TABLEPLUS_BEFORE=$(cat "$INT_PKGS/tableplus.nix")

INT_OUT=$(PKGS_DIR="$INT_PKGS" bash "$SCRIPT_PATH" 2>&1)
INT_STATUS=$?

test_full_run_succeeds() {
    [[ "$INT_STATUS" -eq 0 ]] && ok "full run exits 0" \
        || fail "full run exits 0" "exit 0" "exit ${INT_STATUS}: ${INT_OUT}"
    assert_contains 'Done\.' "$INT_OUT" "full run reports completion"
}
test_full_run_succeeds

test_full_run_dispatches_fetchFromGitHub() {
    assert_file_contains "rev = \"${MOCK_REV}\"" "$INT_PKGS/tmux-plugin-battery.nix" \
        "battery: rev updated by the full run"
    assert_file_contains "hash = \"${SRI_GITHUB_ARCHIVE}\"" "$INT_PKGS/tmux-plugin-battery.nix" \
        "battery: src hash updated by the full run"
}
test_full_run_dispatches_fetchFromGitHub

test_full_run_updates_npm_deps_hash() {
    assert_file_contains "hash = \"${SRI_GITHUB_ARCHIVE}\"" "$INT_PKGS/takt.nix" \
        "takt: src hash updated by the full run"
    assert_file_contains "npmDepsHash = \"${SRI_NPM_DEPS}\"" "$INT_PKGS/takt.nix" \
        "takt: npmDepsHash refreshed by the full run"
}
test_full_run_updates_npm_deps_hash

test_full_run_dispatches_npm() {
    assert_file_contains "version = \"${MOCK_VERSION}\"" "$INT_PKGS/ccstatusline.nix" \
        "ccstatusline: version updated by the full run"
    assert_file_contains "hash = \"${SRI_NPM_TARBALL}\"" "$INT_PKGS/ccstatusline.nix" \
        "ccstatusline: hash updated by the full run"
}
test_full_run_dispatches_npm

test_full_run_dispatches_releases() {
    assert_file_contains "version = \"${MOCK_VERSION}\"" "$INT_PKGS/mise.nix" \
        "mise: version updated by the full run"
    assert_file_contains "$SHA_MACOS_ARM64" "$INT_PKGS/mise.nix" \
        "mise: macos-arm64 sha256 updated by the full run"
}
test_full_run_dispatches_releases

test_full_run_prefers_pnpm_over_npm_and_github() {
    # difit.nix matches fetchPnpmDeps, registry.npmjs.org AND fetchFromGitHub.
    # Dispatch order must pick the pnpm branch, which is the only one that
    # writes all three hashes into their own blocks.
    assert_contains 'pnpm: difit\.nix' "$INT_OUT" \
        "difit is dispatched to the pnpm branch, not npm or github"
    assert_contains "hash = \"${SRI_GITHUB_ARCHIVE}\"" \
        "$(awk '/fetchFromGitHub/,/};/' "$INT_PKGS/difit.nix")" \
        "difit: src hash in the fetchFromGitHub block"
    assert_contains "hash = \"${SRI_NPM_TARBALL}\"" \
        "$(awk '/fetchurl/,/};/' "$INT_PKGS/difit.nix")" \
        "difit: dist hash in the fetchurl block"
    assert_contains "hash = \"${SRI_PNPM_DEPS}\"" \
        "$(awk '/fetchPnpmDeps/,/};/' "$INT_PKGS/difit.nix")" \
        "difit: pnpmDeps hash in the fetchPnpmDeps block"
}
test_full_run_prefers_pnpm_over_npm_and_github

test_full_run_skips_default_nix() {
    assert_eq "$DEFAULT_BEFORE" "$(cat "$INT_PKGS/default.nix")" \
        "default.nix is not modified by the full run"
}
test_full_run_skips_default_nix

test_full_run_warns_and_skips_unrecognized_source() {
    assert_eq "$TABLEPLUS_BEFORE" "$(cat "$INT_PKGS/tableplus.nix")" \
        "a file with no recognized fetch source is not modified"
    assert_contains 'tableplus\.nix has no recognized fetch source' "$INT_OUT" \
        "the full run warns about the unrecognized fetch source"
}
test_full_run_warns_and_skips_unrecognized_source

test_full_run_leaves_no_temp_files() {
    local leftovers
    leftovers=$(find "$INT_PKGS" -name '*.tmp' -print)
    assert_eq "" "$leftovers" "no .tmp files are left behind in pkgs/"
}
test_full_run_leaves_no_temp_files

# ---------- summary ----------
echo ""
echo "========================================"
echo "  Results: ${PASS} passed, ${FAIL} failed"
echo "========================================"
echo ""

[[ $FAIL -eq 0 ]]
