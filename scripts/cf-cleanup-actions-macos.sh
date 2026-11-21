#!/usr/bin/env bash
# 自分以外の CI/CD がすべて終わっていれば、許可ルールを消す。
#
# 同じ範囲を CI と CD で共有するので、実行ごとに作って消すと、同時に走っている
# 別の実行が使っているルールまで消してしまう。そのため最後に終わった実行が片付ける。
# 消した直後に新しい実行が始まっていた場合は、ルールを作り直す。
#
# Env:
#   CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID  (必須)
#   GITHUB_TOKEN  実行中の workflow run の取得用 (必須、actions: read)
#   GITHUB_REPOSITORY, GITHUB_RUN_ID  (必須、Actions が設定する)

set -euo pipefail
: "${CLOUDFLARE_API_TOKEN:?}" "${CLOUDFLARE_ZONE_ID:?}"
: "${GITHUB_TOKEN:?}" "${GITHUB_REPOSITORY:?}" "${GITHUB_RUN_ID:?}"

# shellcheck source=scripts/cf-actions-macos-lib.sh
source "$(dirname "$0")/cf-actions-macos-lib.sh"

active=$(fetch_active_runs)
if [[ -n "$active" ]]; then
    echo "other runs are still active, keeping rules: $(tr '\n' ' ' <<<"$active")" >&2
    exit 0
fi

while read -r id range; do
    [[ -n "$id" ]] && delete_rule "$id" "$range"
done < <(list_rules)

active=$(fetch_active_runs)
if [[ -n "$active" ]]; then
    echo "runs started during cleanup, restoring rules: $(tr '\n' ' ' <<<"$active")" >&2
    sync_rules
fi
