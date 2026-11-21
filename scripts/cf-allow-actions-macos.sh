#!/usr/bin/env bash
# Meta API の actions_macos の範囲を許可ルールとして同期し (足りない範囲は作り、
# 一覧から外れた範囲は消す)、nix.u-naoki.com の nix-cache-info が 200 を返すまで待つ。
# 返らなければ exit 1。
#
# Env:
#   CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID  (必須)
#   GITHUB_TOKEN  Meta API のレート制限回避用 (任意)

set -euo pipefail
: "${CLOUDFLARE_API_TOKEN:?}" "${CLOUDFLARE_ZONE_ID:?}"

# shellcheck source=scripts/cf-actions-macos-lib.sh
source "$(dirname "$0")/cf-actions-macos-lib.sh"

sync_rules
if ! wait_for_cache; then
    ip=$(curl -4fsS https://www.cloudflare.com/cdn-cgi/trace | awk -F= '/^ip=/{print $2}' || true)
    echo "::error::nix.u-naoki.com is still blocked for runner IP ${ip:-unknown}" >&2
    exit 1
fi
