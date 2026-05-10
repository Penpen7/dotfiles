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
| `cursor` | — | nixpkgs 未収録 |
| `docker` | `pkgs.docker` | `docker-desktop` は管理済みだが `docker` cask は別 |
| `font-jetbrains-mono-nerd-font` | `pkgs.nerd-fonts.jetbrains-mono` | `hackgen` 系は管理済み |
| `gstreamer-runtime` | `pkgs.gst_all_1.gstreamer` | |
| `handbrake-app` | `pkgs.handbrake` | formula の `handbrake` も依存として入っている |
| `losslesscut` | `pkgs.losslesscut-bin` | |
| `mactex` | `pkgs.texlive`（attrset） | スキーム指定が必要（例: `texlive.combined.scheme-medium`） |
| `ngrok` | `pkgs.ngrok` | `cloudflared` は管理済み |
| `obs` | `pkgs.obs-studio` | |
| `openemu` | — | nixpkgs 未収録 |
| `raspberry-pi-imager` | `pkgs.rpi-imager` | |
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
| `pict` | — | 組み合わせテストツール（nixpkgs 未収録） |
| `lsix` | `pkgs.lsix` | ターミナルで画像一覧表示 |
| `ytop` | — | システムモニター（nixpkgs 未収録、`bottom` は管理済み） |
| `presenterm` | `pkgs.presenterm` | ターミナルプレゼンツール |
| `typos-cli` | `pkgs.typos` | スペルチェッカー |
| `agg` | `pkgs.agg` | asciinema → GIF 変換 |
| `asciinema-trim` | — | asciinema 録画トリム（nixpkgs 未収録） |
| `alp` | `pkgs.alp` | アクセスログプロファイラ |
| `workq` | — | nixpkgs 未収録 |
| `colima` | `pkgs.colima` | macOS 向けコンテナランタイム |
| `lazygit` | `pkgs.lazygit` | git TUI |
| `nodebrew` | — | Node バージョン管理（dotfiles は `nodejs_24` 固定のため不要） |
| `htop` | `pkgs.htop` | プロセスモニター（`bottom` は管理済みだが別ツール） |
| `watchexec` | `pkgs.watchexec` | ファイル変更監視（`watchman` は管理済みだが別ツール） |

---

## nixpkgs 未収録まとめ

nixpkgs に存在しないため、引き続き brew か別の方法で管理する必要がある。

- `cursor`
- `openemu`
- `pict`
- `ytop`
- `asciinema-trim`
- `workq`
- `nodebrew`（Nix で直接バージョン指定するため不要）

---

## 注意

`nix-darwin` の `cleanup = "zap"` が有効なため、dotfiles に記載のない casks は
次回 `darwin-rebuild switch` 時に削除される。残したい場合は dotfiles に追記が必要。
