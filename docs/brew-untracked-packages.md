# Brew インストール済みパッケージの dotfiles 管理状況

`brew list` と dotfiles (nix-darwin / home-manager) を比較・調査した結果。
調査日: 2026-05-10

---

## Casks — 管理済み

brew list に存在し、dotfiles で管理されているもの。

| cask | 管理方法 | dotfiles の記述箇所 |
|------|---------|-------------------|
| `adobe-acrobat-reader` | nix-darwin cask | `modules/default.nix` |
| `alacritty` | home-manager nixpkg | `standalone/default.nix` |
| `audacity` | home-manager nixpkg | `standalone/default.nix` |
| `brave-browser` | home-manager `programs.brave` | `modules/brave/` |
| `chromedriver` | home-manager nixpkg | `modules/flutter/` |
| `claude` | nix-darwin cask | `modules/default.nix` |
| `cursor` | nix-darwin cask | `modules/default.nix` |
| `cool-retro-term` | home-manager nixpkg | `standalone/default.nix` |
| `discord` | home-manager nixpkg | `modules/discord/`（personal のみ） |
| `docker-desktop` | nix-darwin cask | `modules/default.nix` |
| `font-hackgen` | nix-darwin fonts | `modules/default.nix` |
| `font-hackgen-nerd` | nix-darwin fonts | `modules/default.nix` |
| `google-chrome` | home-manager `programs.google-chrome` | `modules/chrome/` |
| `hashicorp-vagrant` | home-manager nixpkg (`vagrant`) | `standalone/default.nix` |
| `iterm2` | home-manager nixpkg | `standalone/default.nix` |
| `keycastr` | home-manager nixpkg | `standalone/default.nix` |
| `kitty` | home-manager nixpkg | `standalone/default.nix` |
| `logi-options+` | nix-darwin cask | `modules/default.nix` |
| `logi-options-plus` | `logi-options+` の別名のため不要 | — |
| `slack` | home-manager nixpkg | `standalone/default.nix` |
| `tableplus` | nix-darwin cask | `modules/default.nix` |
| `visual-studio-code` | home-manager `programs.vscode` | `modules/vscode/` |
| `vnc-viewer` | home-manager nixpkg (`realvnc-vnc-viewer`) | `standalone/default.nix` |

---

## Casks — 未管理

dotfiles に記述がなく、nixpkgs にも存在しないもの。

| cask | nixpkgs 属性 | 備考 |
|------|-------------|------|
| `betterdisplay` | `pkgs.betterdisplay` | |
| `font-jetbrains-mono-nerd-font` | `pkgs.nerd-fonts.jetbrains-mono` | `hackgen` 系は管理済み |
| `gstreamer-runtime` | `pkgs.gst_all_1.gstreamer` | |
| `handbrake-app` | `pkgs.handbrake` | formula の `handbrake` も依存として入っている |
| `losslesscut` | `pkgs.losslesscut-bin` | |
| `obs` | `pkgs.obs-studio` | |
| `rectangle` | `pkgs.rectangle` | |

---

## Formulae — 未管理（直接インストール相当）

`standalone/default.nix` で多くの formula 相当ツールは Nix で管理されているが、
以下は Nix にも casks にも見当たらないもの（依存パッケージを除く）。

| formula | nixpkgs 属性 | 用途 |
|---------|-------------|------|
| `fastly` | `pkgs.fastly` | Fastly CDN CLI |
| `infracost` | `pkgs.infracost` | インフラコスト見積もり |
| `tbls` | `pkgs.tbls` | DB スキーマドキュメント生成 |
| `lsix` | `pkgs.lsix` | ターミナルで画像一覧表示 |
| `presenterm` | `pkgs.presenterm` | ターミナルプレゼンツール |
| `typos-cli` | `pkgs.typos` | スペルチェッカー |
| `agg` | `pkgs.agg` | asciinema → GIF 変換 |
| `alp` | `pkgs.alp` | アクセスログプロファイラ |
| `colima` | `pkgs.colima` | macOS 向けコンテナランタイム |
| `lazygit` | `pkgs.lazygit` | git TUI |
| `htop` | `pkgs.htop` | プロセスモニター（`bottom` は管理済みだが別ツール） |
| `watchexec` | `pkgs.watchexec` | ファイル変更監視（`watchman` は管理済みだが別ツール） |

---

## インストールしないと判断したもの

brew にインストール済みだが、dotfiles には追加せずアンインストール予定。

| パッケージ | 種別 | 理由 |
|-----------|------|------|
| `docker` | cask | `docker-desktop` で十分 |
| `mactex` | cask | 不要 |
| `ngrok` | cask | `cloudflared` で代替 |
| `openemu` | cask | 不要 |
| `raspberry-pi-imager` | cask | 不要 |
| `pict` | formula | 不要 |
| `asciinema-trim` | formula | 不要 |
| `workq` | formula | 不要 |
| `ytop` | formula | `bottom` で代替 |
| `nodebrew` | formula | `nodejs_24` で固定管理のため不要 |

---

## 注意

`nix-darwin` の `cleanup = "zap"` が有効なため、dotfiles に記載のない casks は
次回 `darwin-rebuild switch` 時に削除される。残したい場合は dotfiles に追記が必要。
