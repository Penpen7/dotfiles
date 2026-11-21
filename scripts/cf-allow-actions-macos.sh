#!/usr/bin/env bash
# GitHub の macOS ランナーから nix.u-naoki.com (Cloudflare の Bot Fight Mode 配下) に
# 届くよう、Meta API の actions_macos の範囲を Cloudflare の IP Access Rule で許可する。
#
# Usage:
#   scripts/cf-allow-actions-macos.sh [allow]  ルールを同期し、キャッシュに届くまで待つ
#   scripts/cf-allow-actions-macos.sh cleanup  ほかに動いている CI/CD がなければルールを消す
#
# Env:
#   CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID  (必須)
#   GITHUB_TOKEN    allow: Meta API のレート制限回避用 (任意)
#                   cleanup: 実行中の workflow run の取得用 (必須、actions: read)
#   GITHUB_REPOSITORY, GITHUB_RUN_ID  cleanup で必須 (Actions が設定する)
#
# allow は Meta API の範囲と同期する (足りない範囲は作り、一覧から外れた範囲は消す)。
# 同期のあと nix.u-naoki.com の nix-cache-info が 200 を返すまで待ち、返らなければ exit 1。
#
# 同じ範囲を CI と CD で共有するので、実行ごとに作って消すと、同時に走っている
# 別の実行が使っているルールまで消してしまう。そのため cleanup は、自分以外の
# CI/CD がすべて終わっているときだけルールを消し、最後に終わった実行が片付ける。
# 消した直後に新しい実行が始まっていた場合は、ルールを作り直す。
# 対象は notes が $RULE_NOTES のルールだけで、手で作ったルールには触らない。
#
# Bot Fight Mode は WAF のカスタムルールでは回避できず、IP Access Rule の allow
# だけが効く。IP Access Rule は IPv4 の範囲を /16 か /24 でしか受け付けないので、
# Meta API の範囲は /24 単位に丸めて登録する。

set -euo pipefail

CACHE_URL="https://nix.u-naoki.com/nix-cache-info"
RULE_NOTES="managed by dotfiles: GitHub actions_macos"

to_slash24() {
    local cidr prefix a b c i n
    while read -r cidr; do
        [[ -z "$cidr" ]] && continue
        [[ "$cidr" == *:* ]] && continue
        if [[ ! "$cidr" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/([0-9]+)$ ]]; then
            echo "invalid CIDR: $cidr" >&2
            return 1
        fi
        a=${BASH_REMATCH[1]} b=${BASH_REMATCH[2]} c=${BASH_REMATCH[3]}
        prefix=${BASH_REMATCH[5]}
        if ((prefix < 16 || prefix > 32)); then
            echo "unsupported prefix: $cidr" >&2
            return 1
        fi
        if ((prefix >= 24)); then
            echo "$a.$b.$c.0/24"
        else
            n=$((1 << (24 - prefix)))
            c=$((c & ~(n - 1)))
            for ((i = 0; i < n; i++)); do
                echo "$a.$b.$((c + i)).0/24"
            done
        fi
    done | awk '!seen[$0]++'
}

fetch_ranges() {
    local auth=()
    [[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
    curl -fsS ${auth[@]+"${auth[@]}"} https://api.github.com/meta | jq -r '.actions_macos[]'
}

CF_RULES_URL() { echo "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/firewall/access_rules/rules"; }

list_rules() {
    curl -fsS -G "$(CF_RULES_URL)" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        --data-urlencode "notes=$RULE_NOTES" \
        --data-urlencode "configuration.target=ip_range" \
        --data-urlencode "per_page=100" |
        jq -r --arg notes "$RULE_NOTES" '.result[] | select(.notes == $notes) | "\(.id) \(.configuration.value)"'
}

create_rule() {
    local range="$1" res
    res=$(curl -sS -X POST "$(CF_RULES_URL)" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H 'Content-Type: application/json' \
        --data "$(jq -cn --arg v "$range" --arg n "$RULE_NOTES" \
            '{mode: "whitelist", configuration: {target: "ip_range", value: $v}, notes: $n}')")
    if [[ "$(jq -r '.success' <<<"$res")" == true ]]; then
        echo "created: $range" >&2
    else
        echo "could not create rule for $range: $(jq -c '.errors' <<<"$res")" >&2
    fi
}

delete_rule() {
    local id="$1" range="$2"
    if curl -fsS -X DELETE "$(CF_RULES_URL)/$id" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" >/dev/null; then
        echo "deleted: $range" >&2
    else
        echo "could not delete rule for $range" >&2
    fi
}

plan_sync() {
    local desired="$1" existing="$2"
    awk '
        FNR == NR { if ($0 != "") want[$0] = 1; next }
        NF == 2 { have[$2] = 1; if (!($2 in want)) print "delete " $1 " " $2 }
        END { for (r in want) if (!(r in have)) print "create " r }
    ' <(printf '%s\n' "$desired") <(printf '%s\n' "$existing") | sort
}

wait_for_cache() {
    local i status
    for i in $(seq 1 12); do
        status=$(curl -4 -s -o /dev/null -w '%{http_code}' "$CACHE_URL" || true)
        echo "nix-cache-info: $status (attempt $i)" >&2
        [[ "$status" == 200 ]] && return 0
        sleep 5
    done
    return 1
}

WORKFLOWS=".github/workflows/ci.yml .github/workflows/cd.yml"

active_runs() {
    local runs_json="$1" self="$2"
    jq -r --arg self "$self" --arg workflows "$WORKFLOWS" '
        ($workflows | split(" ")) as $w
        | .workflow_runs[]
        | select(.status != "completed")
        | select(.id | tostring != $self)
        | select(.path | IN($w[]))
        | .id
    ' <<<"$runs_json"
}

fetch_active_runs() {
    local runs_json
    runs_json=$(curl -fsS -G "https://api.github.com/repos/$GITHUB_REPOSITORY/actions/runs" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github+json" \
        --data-urlencode "per_page=100")
    active_runs "$runs_json" "$GITHUB_RUN_ID"
}

sync_rules() {
    local desired existing action a b
    desired=$(fetch_ranges | to_slash24)
    [[ -n "$desired" ]] || { echo "no actions_macos ranges from Meta API" >&2; return 1; }
    existing=$(list_rules)
    echo "allowing: $(tr '\n' ' ' <<<"$desired")" >&2

    while read -r action a b; do
        case "$action" in
            create) create_rule "$a" ;;
            delete) delete_rule "$a" "$b" ;;
        esac
    done < <(plan_sync "$desired" "$existing")
}

cmd_allow() {
    local ip
    sync_rules
    if ! wait_for_cache; then
        ip=$(curl -4fsS https://www.cloudflare.com/cdn-cgi/trace | awk -F= '/^ip=/{print $2}' || true)
        echo "::error::nix.u-naoki.com is still blocked for runner IP ${ip:-unknown}" >&2
        return 1
    fi
}

cmd_cleanup() {
    : "${GITHUB_TOKEN:?}" "${GITHUB_REPOSITORY:?}" "${GITHUB_RUN_ID:?}"
    local active id range
    active=$(fetch_active_runs)
    if [[ -n "$active" ]]; then
        echo "other runs are still active, keeping rules: $(tr '\n' ' ' <<<"$active")" >&2
        return 0
    fi

    while read -r id range; do
        [[ -n "$id" ]] && delete_rule "$id" "$range"
    done < <(list_rules)

    active=$(fetch_active_runs)
    if [[ -n "$active" ]]; then
        echo "runs started during cleanup, restoring rules: $(tr '\n' ' ' <<<"$active")" >&2
        sync_rules
    fi
}

main() {
    : "${CLOUDFLARE_API_TOKEN:?}" "${CLOUDFLARE_ZONE_ID:?}"
    case "${1:-allow}" in
        allow) cmd_allow ;;
        cleanup) cmd_cleanup ;;
        *)
            echo "usage: $0 [allow|cleanup]" >&2
            return 2
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
