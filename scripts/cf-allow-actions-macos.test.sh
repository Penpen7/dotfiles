#!/usr/bin/env bash
# Tests for scripts/cf-allow-actions-macos.sh
#
# Usage: bash scripts/cf-allow-actions-macos.test.sh
#
# Network を使う関数 (Meta API / Cloudflare API) は対象外で、純粋な関数だけを試す。
#   to_slash24  - Meta API の CIDR を IP Access Rule で使える /24 に丸める
#   plan_sync   - 望ましい範囲と既存ルールから create/delete を決める
#   active_runs - workflow run の一覧から、自分以外で動いている CI/CD を選ぶ

set -uo pipefail

PASS=0
FAIL=0

ok() {
    echo "  ok:   $1"
    PASS=$((PASS + 1))
}
fail() {
    echo "  FAIL: $1"
    echo "        expected: $(printf '%q' "$2")"
    echo "        actual:   $(printf '%q' "$3")"
    FAIL=$((FAIL + 1))
}
assert_eq() {
    if [[ "$1" == "$2" ]]; then ok "$3"; else fail "$3" "$1" "$2"; fi
}

# shellcheck source=scripts/cf-allow-actions-macos.sh
source "$(dirname "$0")/cf-allow-actions-macos.sh"
set +e

echo "to_slash24"

assert_eq "13.105.117.0/24" \
    "$(echo 13.105.117.0/24 | to_slash24)" \
    "/24 はそのまま"

assert_eq "13.105.220.0/24" \
    "$(printf '%s\n' 13.105.220.0/25 13.105.220.128/27 13.105.220.188/31 | to_slash24)" \
    "/24 より狭い範囲は含む /24 にまとめて重複を消す"

assert_eq "$(printf '%s\n' 10.0.4.0/24 10.0.5.0/24 10.0.6.0/24 10.0.7.0/24)" \
    "$(echo 10.0.5.0/22 | to_slash24)" \
    "/24 より広い範囲は境界に揃えて /24 に分割する"

assert_eq "1.2.3.0/24" \
    "$(printf '%s\n' 2001:db8::/32 1.2.3.4/32 '' | to_slash24)" \
    "IPv6 と空行は読み飛ばす"

out=$(echo 10.0.0.0/8 | to_slash24 2>/dev/null)
rc=$?
assert_eq "1:" "$rc:$out" "/16 より広い範囲は失敗する"

out=$(echo not-a-cidr | to_slash24 2>/dev/null)
rc=$?
assert_eq "1:" "$rc:$out" "CIDR でない値は失敗する"

echo "plan_sync"

desired=$(printf '%s\n' 13.105.117.0/24 13.105.49.0/24)

assert_eq "$(printf '%s\n' "create 13.105.117.0/24" "create 13.105.49.0/24")" \
    "$(plan_sync "$desired" "")" \
    "ルールがなければ全部作る"

assert_eq "" \
    "$(plan_sync "$desired" "$(printf '%s\n' "id1 13.105.117.0/24" "id2 13.105.49.0/24")")" \
    "揃っていれば何もしない"

assert_eq "$(printf '%s\n' "create 13.105.49.0/24" "delete id9 13.105.99.0/24")" \
    "$(plan_sync "$desired" "$(printf '%s\n' "id1 13.105.117.0/24" "id9 13.105.99.0/24")")" \
    "足りない範囲を作り、外れた範囲を消す"

echo "active_runs"

runs='{"workflow_runs": [
  {"id": 1, "path": ".github/workflows/ci.yml", "status": "in_progress"},
  {"id": 2, "path": ".github/workflows/cd.yml", "status": "queued"},
  {"id": 3, "path": ".github/workflows/ci.yml", "status": "completed"},
  {"id": 4, "path": ".github/workflows/update-flake-lock.yml", "status": "in_progress"},
  {"id": 5, "path": ".github/workflows/cd.yml", "status": "waiting"}
]}'

assert_eq "$(printf '%s\n' 2 5)" \
    "$(active_runs "$runs" 1)" \
    "自分と完了済みと CI/CD 以外を除き、待機中も含める"

assert_eq "" \
    "$(active_runs '{"workflow_runs": [{"id": 1, "path": ".github/workflows/ci.yml", "status": "in_progress"}]}' 1)" \
    "自分しかいなければ空"

echo
echo "passed: $PASS, failed: $FAIL"
((FAIL == 0))
