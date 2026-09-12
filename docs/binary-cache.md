# Binary cache (Cloudflare R2)

`master` への push で darwin システムをビルドし、その closure を自前のバイナリ
キャッシュへ push する CD (`.github/workflows/cd.yml`) のセットアップ手順。

ローカルの `darwin-rebuild switch` が、CI が既にビルドしたパスをダウンロードで
済ませられるようにするのが目的。

## 仕組み

`nix copy` は指定したパスの **closure 全体**を対象にするが、宛先に既に存在する
パス (narinfo の有無で判定) はスキップする。したがって初回だけ重く、以降は
差分だけがアップロードされる。

R2 を選ぶ理由は egress が無料なこと。ダウンロードが何 GB になっても転送料は
発生せず、課金されるのはストレージ (GB-month) と操作回数だけ。個人利用の規模
なら月 $0〜1 に収まる。

## 1. R2 バケットを作る

Cloudflare ダッシュボード → R2 → Create bucket。

- **Location Hint: Asia-Pacific (APAC)** — 後から変更できないので最初に指定する
- **Object versioning: 無効のまま** — 旧バージョンもストレージに計上されるため
- **Storage class: Standard** — Infrequent Access は取得料と 30 日の最低保存期間
  があり、頻繁に読むキャッシュには向かない

作成後、Settings → Object lifecycle rules に以下を追加する。

| ルール | 目的 |
| --- | --- |
| Abort incomplete multipart uploads after 7 days | CI が途中で落ちた際のゴミを回収する |
| Delete objects 90 days after creation | 古い世代を捨てる。消えたパスは次の CD で再 push されるので自己修復する |

## 2. 署名鍵を作る

```sh
nix-store --generate-binary-cache-key \
  penpen7-dotfiles-1 cache-priv-key.pem cache-pub-key.pem
```

- `cache-priv-key.pem` → GitHub Secret へ。**リポジトリにコミットしない**
- `cache-pub-key.pem` → 公開鍵。クライアント側の `trusted-public-keys` に入れる

バケットを public にしても、この署名検証があるので第三者が偽の NAR を注入する
ことはできない (書き込みには API トークンが必要)。

## 3. R2 API トークンを作る

R2 → Manage API tokens → Create token。

- Permission: **Object Read & Write**
- Scope: **作成したバケットのみ**。アカウント全体の権限を CI に置かない

発行される Access Key ID / Secret Access Key を控える。

## 4. カスタムドメインを接続する

バケット → Settings → Custom Domains で、Cloudflare 管理下のドメインを接続する。

`*.r2.dev` は開発用でレート制限があるため常用しない。

Nix は substituter に認証なしの GET を投げるので、この URL は公開アクセスに
なる。`/nix/store` に入るものは全て公開される前提で運用すること (秘密情報を
store に入れる構成に変える場合は要再検討)。

## 5. GitHub に値を登録する

Settings → Secrets and variables → Actions。

### Variables

| 名前 | 値の例 |
| --- | --- |
| `NIX_CACHE_BUCKET` | `penpen7-nix-cache` |
| `R2_ACCOUNT_ID` | Cloudflare のアカウント ID |
| `NIX_CACHE_URL` | `https://nix-cache.example.com` |
| `NIX_CACHE_PUBLIC_KEY` | `penpen7-dotfiles-1:xxxx...` (`cache-pub-key.pem` の中身) |

`NIX_CACHE_BUCKET` が未設定の間、CD ジョブは丸ごとスキップされる。

### Secrets

| 名前 | 値 |
| --- | --- |
| `R2_ACCESS_KEY_ID` | 手順 3 の Access Key ID |
| `R2_SECRET_ACCESS_KEY` | 手順 3 の Secret Access Key |
| `NIX_CACHE_SIGNING_KEY` | `cache-priv-key.pem` の中身 |

## 6. クライアント側に substituter を足す

`flake.nix` の `nixConfig` に追記する。

```nix
nixConfig = {
  extra-substituters = [
    "https://nix-community.cachix.org"
    "https://nix-cache.example.com"      # ← 手順 4 のドメイン
  ];
  extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "penpen7-dotfiles-1:xxxx..."         # ← 手順 2 の公開鍵
  ];
};
```

`nixConfig` は trusted user でないと反映されないため、効かない場合は
`/etc/nix/nix.conf` に直接書くか、`nix.settings.trusted-users` に自分を足す。

## 7. 動作確認

```sh
# キャッシュが公開されているか
curl -sI https://nix-cache.example.com/nix-cache-info

# 適当なパスの narinfo が引けるか
curl -s https://nix-cache.example.com/<hash>.narinfo

# Cloudflare のエッジキャッシュに載っているか (HIT なら R2 に到達していない)
curl -sI https://nix-cache.example.com/nix-cache-info | grep -i cf-cache-status
```

## 運用

### サイズを測る

```sh
rclone size r2:penpen7-nix-cache
```

課金は「日ごとのピーク使用量を 30 日で平均した GB-month」なので、上の瞬間値は
請求額と一致しない。実際の推移は R2 → バケット → Metrics で見る。

### 手動で掃除する

ライフサイクルルールで自動的に消えるが、一度リセットしたい場合は空にして
次の CD を待てばよい。

```sh
rclone purge r2:penpen7-nix-cache
```

`nix copy` は宛先に無いパスを再アップロードするので、消しても次回の push で
必要なぶんが戻る。

## トラブルシューティング

### `nix copy` が `S3 support is not enabled` で落ちる

Nix の `s3://` ストアは aws-sdk-cpp を組み込んでビルドされている必要があり、
配布ビルドによっては無効になっている。その場合は一旦ローカルの `file://`
キャッシュに書き出してから rclone で上げる。

```sh
nix copy --to "file://${RUNNER_TEMP}/cache?compression=zstd&secret-key=${KEYFILE}" "${OUT}"
rclone copy "${RUNNER_TEMP}/cache" "r2:${BUCKET}"
```

NAR のファイル名は内容から決まるため、rclone は同一ファイルを自動的にスキップ
する。ただし `nix copy` 側は宛先の状況を知らないので、毎回 closure 全体を
再圧縮することになり初回以降も時間がかかる。

### push したのにローカルで使われない

`~/.cache/nix/binary-cache-v6.sqlite` に 404 の結果が残っている可能性がある
(既定で 1 時間保持)。

```sh
rm -rf ~/.cache/nix
```

### 署名が信頼されない

`trusted-public-keys` に公開鍵が入っているか、`nixConfig` が trusted user
制限で無視されていないかを確認する。

```sh
nix config show | grep -E 'substituters|trusted-public-keys'
```
