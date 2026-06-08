#!/usr/bin/env bash
# Tests for scripts/update-pkgs-hash.sh
#
# Usage: bash scripts/update-pkgs-hash.test.sh
#
# Test scope:
#   Unit        - Parameter extraction patterns, URL construction, sed replacement
#   Function    - update_fetchFromGitHub(), update_fetchurl() (require script to exist)
#   Integration - Full script run against temp pkgs dir (require script to exist)

set -uo pipefail

PASS=0
FAIL=0
SKIP=0

# ---------- minimal test framework ----------

ok()   { echo "  ok:   $1"; PASS=$((PASS+1)); }
fail() {
    local msg="$1" exp="${2:-}" got="${3:-}"
    echo "  FAIL: $msg"
    [[ -n "$exp" ]] && echo "        expected: $exp"
    [[ -n "$got" ]] && echo "        actual:   $got"
    FAIL=$((FAIL+1))
}
skip() { echo "  skip: $1"; SKIP=$((SKIP+1)); }

assert_eq() {
    local exp="$1" got="$2" msg="$3"
    [[ "$exp" == "$got" ]] && ok "$msg" || fail "$msg" "$exp" "$got"
}

assert_contains() {
    local pattern="$1" str="$2" msg="$3"
    echo "$str" | grep -q "$pattern" && ok "$msg" \
        || fail "$msg" "(pattern: $pattern)" "$str"
}

assert_not_contains() {
    local pattern="$1" str="$2" msg="$3"
    echo "$str" | grep -q "$pattern" \
        && fail "$msg" "(should not match: $pattern)" "$str" \
        || ok "$msg"
}

assert_file_contains() {
    local pattern="$1" file="$2" msg="$3"
    grep -q "$pattern" "$file" && ok "$msg" \
        || fail "$msg" "(pattern: $pattern)" "$(cat "$file")"
}

assert_file_not_contains() {
    local pattern="$1" file="$2" msg="$3"
    grep -q "$pattern" "$file" \
        && fail "$msg" "(should not match: $pattern)" "$(cat "$file")" \
        || ok "$msg"
}

# ---------- setup ----------

TMP=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '$TMP'" EXIT

MOCK_BIN="$TMP/bin"
mkdir -p "$MOCK_BIN"

# Mock: nix-prefetch-url
# Records call args to $TMP/prefetch.calls and returns a fixed base32 hash.
cat > "$MOCK_BIN/nix-prefetch-url" << MOCK
#!/usr/bin/env bash
UNPACK=""
for arg in "\$@"; do
  [[ "\$arg" == "--unpack" ]] && UNPACK="--unpack"
done
echo "\$UNPACK \$*" >> "${TMP}/prefetch.calls"
printf '%s\n' "1111111111111111111111111111111111111111111111111111"
MOCK
chmod +x "$MOCK_BIN/nix-prefetch-url"

# Mock: nix (handles "nix hash to-sri --type sha256 <base32>")
cat > "$MOCK_BIN/nix" << 'MOCK'
#!/usr/bin/env bash
printf 'sha256-MOCKHASH000000000000000000000000000000000000=\n'
MOCK
chmod +x "$MOCK_BIN/nix"

export PATH="$MOCK_BIN:$PATH"

SCRIPT_DIR_TEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR_TEST/update-pkgs-hash.sh"

# ---------- fixture factory ----------

create_pkgs_fixtures() {
    local pkgs_dir="$1"
    mkdir -p "$pkgs_dir"

    # fetchFromGitHub fixture
    cat > "$pkgs_dir/tmux-plugin-battery.nix" << 'NIX'
{ pkgs }:
pkgs.tmuxPlugins.battery.overrideAttrs (_: {
  version = "unstable-2025-12-30";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-battery";
    rev = "43832651ede43f54dcf0588727c1957fe648d57d";
    hash = "sha256-OLDHASH0000000000000000000000000000000000000=";
  };
})
NIX

    # fetchurl fixture (URL contains ${version} variable)
    cat > "$pkgs_dir/ccstatusline.nix" << 'NIX'
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "ccstatusline";
  version = "2.2.19";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${version}.tgz";
    hash = "sha256-OLDHASH1111111111111111111111111111111111111=";
  };
}
NIX

    # fetchFromGitHub with additional npmDepsHash (must NOT be touched)
    cat > "$pkgs_dir/takt.nix" << 'NIX'
{ pkgs }:
pkgs.buildNpmPackage {
  pname = "takt";
  version = "unstable-2026-05-15";

  src = pkgs.fetchFromGitHub {
    owner = "nrslib";
    repo = "takt";
    rev = "598bf88d504f3963cd21fea5a70665b1c482cf5b";
    hash = "sha256-OLDHASH2222222222222222222222222222222222222=";
  };

  npmDepsHash = "sha256-NPMHASH0000000000000000000000000000000000000=";
}
NIX

    # default.nix: no fetch source, must be skipped entirely
    cat > "$pkgs_dir/default.nix" << 'NIX'
{
  overlays.default = final: prev: {
    takt = import ./takt.nix { pkgs = final; };
  };
}
NIX
}

PKGS_FIXTURES="$TMP/pkgs"
create_pkgs_fixtures "$PKGS_FIXTURES"

# ==============================================================
# [Unit] Parameter extraction: fetchFromGitHub
# ==============================================================
echo ""
echo "=== [Unit] Parameter extraction: fetchFromGitHub ==="

test_extract_owner() {
    # Given: a fetchFromGitHub .nix file
    local file="$PKGS_FIXTURES/tmux-plugin-battery.nix"
    # When: extracting owner with the grep/sed pattern
    local owner
    owner=$(grep -E '^\s+owner = ' "$file" | sed -E 's/.*owner = "([^"]*)".*/\1/')
    # Then: correct owner is returned
    assert_eq "tmux-plugins" "$owner" "owner extracted from fetchFromGitHub file"
}
test_extract_owner

test_extract_repo() {
    # Given: a fetchFromGitHub .nix file
    local file="$PKGS_FIXTURES/tmux-plugin-battery.nix"
    # When: extracting repo
    local repo
    repo=$(grep -E '^\s+repo = ' "$file" | sed -E 's/.*repo = "([^"]*)".*/\1/')
    # Then: correct repo is returned
    assert_eq "tmux-battery" "$repo" "repo extracted from fetchFromGitHub file"
}
test_extract_repo

test_extract_rev() {
    # Given: a fetchFromGitHub .nix file
    local file="$PKGS_FIXTURES/tmux-plugin-battery.nix"
    # When: extracting rev
    local rev
    rev=$(grep -E '^\s+rev = ' "$file" | sed -E 's/.*rev = "([^"]*)".*/\1/')
    # Then: full commit hash is returned
    assert_eq "43832651ede43f54dcf0588727c1957fe648d57d" "$rev" \
        "rev (commit hash) extracted from fetchFromGitHub file"
}
test_extract_rev

test_extract_owner_from_takt() {
    # Given: takt.nix (fetchFromGitHub with additional npmDepsHash)
    local file="$PKGS_FIXTURES/takt.nix"
    # When: extracting owner
    local owner
    owner=$(grep -E '^\s+owner = ' "$file" | sed -E 's/.*owner = "([^"]*)".*/\1/')
    # Then: correct owner
    assert_eq "nrslib" "$owner" "owner extracted from takt.nix"
}
test_extract_owner_from_takt

# ==============================================================
# [Unit] URL construction: fetchFromGitHub
# ==============================================================
echo ""
echo "=== [Unit] URL construction: fetchFromGitHub ==="

test_github_archive_url_format() {
    # Given: owner, repo, rev extracted from file
    local owner="tmux-plugins" repo="tmux-battery" rev="43832651ede43f54dcf0588727c1957fe648d57d"
    # When: constructing the GitHub archive URL
    local url="https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"
    # Then: URL points to the correct tar.gz archive
    assert_eq \
        "https://github.com/tmux-plugins/tmux-battery/archive/43832651ede43f54dcf0588727c1957fe648d57d.tar.gz" \
        "$url" \
        "GitHub archive URL constructed with correct format"
}
test_github_archive_url_format

test_github_archive_url_uses_tar_gz() {
    # Given: any owner/repo/rev
    local owner="nrslib" repo="takt" rev="598bf88d504f3963cd21fea5a70665b1c482cf5b"
    # When: constructing URL
    local url="https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"
    # Then: URL ends with .tar.gz (not .zip, not bare rev)
    assert_contains '\.tar\.gz$' "$url" "URL ends with .tar.gz"
}
test_github_archive_url_uses_tar_gz

# ==============================================================
# [Unit] Parameter extraction: fetchurl with ${version} substitution
# ==============================================================
echo ""
echo "=== [Unit] Parameter extraction: fetchurl (version substitution) ==="

test_extract_version_from_fetchurl_file() {
    # Given: ccstatusline.nix (fetchurl, has version = "...")
    local file="$PKGS_FIXTURES/ccstatusline.nix"
    # When: extracting version
    local version
    version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')
    # Then: semver string is returned
    assert_eq "2.2.19" "$version" "version extracted from fetchurl file"
}
test_extract_version_from_fetchurl_file

test_extract_raw_url_contains_version_placeholder() {
    # Given: ccstatusline.nix
    local file="$PKGS_FIXTURES/ccstatusline.nix"
    # When: extracting raw URL (before substitution)
    local url_raw
    url_raw=$(grep -E '^\s+url = ' "$file" | sed -E 's/.*url = "([^"]*)".*/\1/')
    # Then: raw URL still contains the ${version} literal placeholder
    assert_contains '\${version}' "$url_raw" \
        "raw URL contains literal \${version} placeholder before substitution"
}
test_extract_raw_url_contains_version_placeholder

test_version_substituted_in_url() {
    # Given: version and url_raw extracted from ccstatusline.nix
    local file="$PKGS_FIXTURES/ccstatusline.nix"
    local version url_raw url
    version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')
    url_raw=$(grep -E '^\s+url = '  "$file" | sed -E 's/.*url = "([^"]*)".*/\1/')
    # When: substituting ${version} with the actual version value
    url=$(echo "$url_raw" | sed "s/\${version}/$version/g")
    # Then: resulting URL has no placeholder and contains the version number
    assert_eq \
        "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.19.tgz" \
        "$url" \
        "\${version} substituted correctly in fetchurl URL"
}
test_version_substituted_in_url

test_substituted_url_has_no_placeholder() {
    # Given: same substitution as above
    local file="$PKGS_FIXTURES/ccstatusline.nix"
    local version url_raw url
    version=$(grep -E '^\s+version = ' "$file" | sed -E 's/.*version = "([^"]*)".*/\1/')
    url_raw=$(grep -E '^\s+url = ' "$file"  | sed -E 's/.*url = "([^"]*)".*/\1/')
    url=$(echo "$url_raw" | sed "s/\${version}/$version/g")
    # Then: no ${version} remains in the substituted URL
    assert_not_contains '\${version}' "$url" \
        "substituted URL has no remaining \${version} placeholder"
}
test_substituted_url_has_no_placeholder

# ==============================================================
# [Unit] Hash replacement: sed pattern correctness
# ==============================================================
echo ""
echo "=== [Unit] Hash replacement: sed pattern ==="

test_sed_replaces_hash_field() {
    # Given: a file with a hash = "sha256-..." line
    local file="$TMP/sed_basic.nix"
    cat > "$file" << 'NIX'
  src = pkgs.fetchFromGitHub {
    hash = "sha256-OLDHASH0000000000000000000000000000000000000=";
  };
NIX
    local new_hash="sha256-MOCKHASH000000000000000000000000000000000000="
    # When: sed replacement pattern is applied
    sed -i '' "s|hash = \"sha256-[^\"]*\"|hash = \"${new_hash}\"|" "$file"
    # Then: new hash appears in the file
    assert_file_contains "$new_hash" "$file" "sed replaces hash field with new SRI hash"
}
test_sed_replaces_hash_field

test_sed_pattern_does_not_match_npmDepsHash() {
    # Given: a file with both hash = "..." and npmDepsHash = "..."
    local file="$TMP/sed_npm.nix"
    local original_npm_hash="sha256-NPMHASH0000000000000000000000000000000000000="
    cat > "$file" << NIX
  src = pkgs.fetchFromGitHub {
    hash = "sha256-OLDHASH2222222222222222222222222222222222222=";
  };
  npmDepsHash = "$original_npm_hash";
NIX
    local new_hash="sha256-MOCKHASH000000000000000000000000000000000000="
    # When: the hash = "sha256-..." sed pattern is applied
    sed -i '' "s|hash = \"sha256-[^\"]*\"|hash = \"${new_hash}\"|" "$file"
    # Then: npmDepsHash is NOT modified
    assert_file_contains "$original_npm_hash" "$file" \
        "npmDepsHash is preserved (sed pattern does not match npmDepsHash line)"
    # And: the hash field IS updated
    assert_file_contains "$new_hash" "$file" \
        "hash field is updated while npmDepsHash remains untouched"
}
test_sed_pattern_does_not_match_npmDepsHash

test_sed_replaces_only_one_hash_occurrence() {
    # Given: a file with exactly one hash = "..." field
    local file="$TMP/sed_once.nix"
    cat > "$file" << 'NIX'
  src = pkgs.fetchFromGitHub {
    hash = "sha256-OLDHASH0000000000000000000000000000000000000=";
  };
NIX
    local new_hash="sha256-MOCKHASH000000000000000000000000000000000000="
    # When: sed is applied
    sed -i '' "s|hash = \"sha256-[^\"]*\"|hash = \"${new_hash}\"|" "$file"
    # Then: OLDHASH no longer exists
    assert_file_not_contains "OLDHASH" "$file" \
        "old hash is no longer present after replacement"
}
test_sed_replaces_only_one_hash_occurrence

# ==============================================================
# [Unit] Skip logic: default.nix
# ==============================================================
echo ""
echo "=== [Unit] Skip logic: default.nix ==="

test_default_nix_has_no_hash_field() {
    # Given: default.nix (no fetch source, only imports)
    local file="$PKGS_FIXTURES/default.nix"
    # When: checking for hash = "..." line
    local count
    count=$(grep -c 'hash = ' "$file" || true)
    # Then: zero matches — no hash to update
    assert_eq "0" "$count" "default.nix has no hash field (correct skip candidate)"
}
test_default_nix_has_no_hash_field

test_default_nix_has_no_fetch_source() {
    # Given: default.nix
    local file="$PKGS_FIXTURES/default.nix"
    # When: checking for fetchFromGitHub or fetchurl
    local count
    count=$(grep -c 'fetchFromGitHub\|fetchurl' "$file" || true)
    # Then: zero matches — no fetch source to process
    assert_eq "0" "$count" "default.nix has no fetchFromGitHub or fetchurl (not processed)"
}
test_default_nix_has_no_fetch_source

# ==============================================================
# [Function] update_fetchFromGitHub / update_fetchurl
# Requires the production script to be present.
# ==============================================================
echo ""
echo "=== [Function] update_fetchFromGitHub and update_fetchurl ==="

if [[ ! -f "$SCRIPT_PATH" ]]; then
    skip "update_fetchFromGitHub updates hash field (script not yet implemented)"
    skip "update_fetchFromGitHub passes --unpack to nix-prefetch-url"
    skip "update_fetchurl updates hash field (script not yet implemented)"
    skip "update_fetchurl does NOT pass --unpack to nix-prefetch-url"
    skip "update_fetchFromGitHub on takt.nix does not touch npmDepsHash"
else
    # Source the script to load its functions.
    # Production script must guard main execution with:
    #   [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
    # shellcheck source=/dev/null
    source "$SCRIPT_PATH"

    test_update_fetchFromGitHub_updates_hash() {
        # Given: a fetchFromGitHub file with old hash
        local file="$TMP/battery_func.nix"
        cp "$PKGS_FIXTURES/tmux-plugin-battery.nix" "$file"
        # When: update_fetchFromGitHub is called
        update_fetchFromGitHub "$file"
        # Then: hash is updated to the mock hash value
        assert_file_contains \
            "sha256-MOCKHASH000000000000000000000000000000000000=" \
            "$file" \
            "update_fetchFromGitHub writes new SRI hash to file"
    }
    test_update_fetchFromGitHub_updates_hash

    test_update_fetchFromGitHub_uses_unpack_flag() {
        # Given: a fresh call log
        rm -f "$TMP/prefetch.calls"
        local file="$TMP/battery_unpack.nix"
        cp "$PKGS_FIXTURES/tmux-plugin-battery.nix" "$file"
        # When: update_fetchFromGitHub is called
        update_fetchFromGitHub "$file"
        # Then: nix-prefetch-url was invoked with --unpack
        local calls
        calls=$(cat "$TMP/prefetch.calls" 2>/dev/null || echo "")
        assert_contains "\-\-unpack" "$calls" \
            "nix-prefetch-url called with --unpack for fetchFromGitHub (tarball hash matches source hash)"
    }
    test_update_fetchFromGitHub_uses_unpack_flag

    test_update_fetchurl_updates_hash() {
        # Given: a fetchurl file with old hash
        local file="$TMP/cc_func.nix"
        cp "$PKGS_FIXTURES/ccstatusline.nix" "$file"
        # When: update_fetchurl is called
        update_fetchurl "$file"
        # Then: hash is updated to the mock hash value
        assert_file_contains \
            "sha256-MOCKHASH000000000000000000000000000000000000=" \
            "$file" \
            "update_fetchurl writes new SRI hash to file"
    }
    test_update_fetchurl_updates_hash

    test_update_fetchurl_does_not_use_unpack_flag() {
        # Given: a fresh call log
        rm -f "$TMP/prefetch.calls"
        local file="$TMP/cc_nounpack.nix"
        cp "$PKGS_FIXTURES/ccstatusline.nix" "$file"
        # When: update_fetchurl is called
        update_fetchurl "$file"
        # Then: nix-prefetch-url was called WITHOUT --unpack
        local calls
        calls=$(cat "$TMP/prefetch.calls" 2>/dev/null || echo "")
        assert_not_contains "\-\-unpack" "$calls" \
            "nix-prefetch-url called WITHOUT --unpack for plain fetchurl"
    }
    test_update_fetchurl_does_not_use_unpack_flag

    test_update_fetchFromGitHub_preserves_npmDepsHash() {
        # Given: takt.nix which has both hash and npmDepsHash
        local file="$TMP/takt_func.nix"
        cp "$PKGS_FIXTURES/takt.nix" "$file"
        local original_npm_hash
        original_npm_hash=$(grep 'npmDepsHash = ' "$file" \
            | sed -E 's/.*npmDepsHash = "([^"]*)".*/\1/')
        # When: update_fetchFromGitHub is called
        update_fetchFromGitHub "$file"
        # Then: npmDepsHash is unchanged
        assert_file_contains "$original_npm_hash" "$file" \
            "update_fetchFromGitHub does not modify npmDepsHash in takt.nix"
    }
    test_update_fetchFromGitHub_preserves_npmDepsHash
fi

# ==============================================================
# [Integration] Full script run across all pkgs/*.nix files
# Requires the production script to be present.
# Verifies: correct dispatch, default.nix skip, npmDepsHash preservation.
# ==============================================================
echo ""
echo "=== [Integration] Full script run ==="

if [[ ! -f "$SCRIPT_PATH" ]]; then
    skip "fetchFromGitHub hashes updated by full script run (script not yet implemented)"
    skip "fetchurl hash updated by full script run (script not yet implemented)"
    skip "default.nix not modified by full script run (script not yet implemented)"
    skip "npmDepsHash in takt.nix not modified by full script run (script not yet implemented)"
else
    test_full_run_updates_fetchFromGitHub_hashes() {
        # Given: temp pkgs dir with all fixture files
        local pkgs_dir="$TMP/int_pkgs"
        create_pkgs_fixtures "$pkgs_dir"
        # When: script is run with PKGS_DIR overriding to temp dir
        PKGS_DIR="$pkgs_dir" bash "$SCRIPT_PATH"
        # Then: fetchFromGitHub hash in battery file is updated
        assert_file_contains \
            "sha256-MOCKHASH000000000000000000000000000000000000=" \
            "$pkgs_dir/tmux-plugin-battery.nix" \
            "tmux-plugin-battery.nix hash is updated by full run"
        # And: fetchFromGitHub hash in takt.nix is updated
        assert_file_contains \
            "sha256-MOCKHASH000000000000000000000000000000000000=" \
            "$pkgs_dir/takt.nix" \
            "takt.nix hash is updated by full run"
    }
    test_full_run_updates_fetchFromGitHub_hashes

    test_full_run_updates_fetchurl_hash() {
        # Given: temp pkgs dir (re-use from previous or create fresh)
        local pkgs_dir="$TMP/int_pkgs2"
        create_pkgs_fixtures "$pkgs_dir"
        # When: script is run
        PKGS_DIR="$pkgs_dir" bash "$SCRIPT_PATH"
        # Then: fetchurl hash in ccstatusline is updated
        assert_file_contains \
            "sha256-MOCKHASH000000000000000000000000000000000000=" \
            "$pkgs_dir/ccstatusline.nix" \
            "ccstatusline.nix hash is updated by full run"
    }
    test_full_run_updates_fetchurl_hash

    test_full_run_skips_default_nix() {
        # Given: temp pkgs dir
        local pkgs_dir="$TMP/int_pkgs3"
        create_pkgs_fixtures "$pkgs_dir"
        local before
        before=$(cat "$pkgs_dir/default.nix")
        # When: script is run
        PKGS_DIR="$pkgs_dir" bash "$SCRIPT_PATH"
        # Then: default.nix is not modified
        local after
        after=$(cat "$pkgs_dir/default.nix")
        assert_eq "$before" "$after" "default.nix is not modified by full run"
    }
    test_full_run_skips_default_nix

    test_full_run_preserves_npmDepsHash_in_takt() {
        # Given: temp pkgs dir
        local pkgs_dir="$TMP/int_pkgs4"
        create_pkgs_fixtures "$pkgs_dir"
        local original_npm_hash
        original_npm_hash=$(grep 'npmDepsHash = ' "$pkgs_dir/takt.nix" \
            | sed -E 's/.*npmDepsHash = "([^"]*)".*/\1/')
        # When: script is run
        PKGS_DIR="$pkgs_dir" bash "$SCRIPT_PATH"
        # Then: npmDepsHash is unchanged
        assert_file_contains "$original_npm_hash" "$pkgs_dir/takt.nix" \
            "takt.nix npmDepsHash is not modified by full run"
    }
    test_full_run_preserves_npmDepsHash_in_takt

    test_full_run_skips_unrecognized_source() {
        # Given: temp pkgs dir with a .nix file that has no recognized fetch source
        local pkgs_dir="$TMP/int_pkgs5"
        create_pkgs_fixtures "$pkgs_dir"
        cat > "$pkgs_dir/unknown-source.nix" << 'NIX'
{ pkgs }:
pkgs.writeText "hello" "hello world"
NIX
        local before
        before=$(cat "$pkgs_dir/unknown-source.nix")
        # When: script is run
        PKGS_DIR="$pkgs_dir" bash "$SCRIPT_PATH" 2>/dev/null
        # Then: file with no recognized fetch source is not modified (warn+skip)
        local after
        after=$(cat "$pkgs_dir/unknown-source.nix")
        assert_eq "$before" "$after" \
            "unrecognized fetch source file is not modified by full run (warn+skip)"
    }
    test_full_run_skips_unrecognized_source
fi

# ---------- summary ----------
echo ""
echo "========================================"
echo "  Results: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped"
echo "========================================"
echo ""

[[ $FAIL -eq 0 ]]
