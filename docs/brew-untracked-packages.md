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
| `font-jetbrains-mono-nerd-font` | nix-darwin fonts (`nerd-fonts.jetbrains-mono`) | `modules/default.nix` |
| `google-chrome` | home-manager `programs.google-chrome` | `modules/chrome/` |
| `gstreamer-runtime` | home-manager nixpkg (`gst_all_1.gstreamer`) | `standalone/default.nix` |
| `handbrake-app` | home-manager nixpkg (`handbrake`) | `standalone/default.nix` |
| `hashicorp-vagrant` | home-manager nixpkg (`vagrant`) | `standalone/default.nix` |
| `iterm2` | home-manager nixpkg | `standalone/default.nix` |
| `keycastr` | home-manager nixpkg | `standalone/default.nix` |
| `kitty` | home-manager nixpkg | `standalone/default.nix` |
| `logi-options+` | nix-darwin cask | `modules/default.nix` |
| `losslesscut` | home-manager nixpkg (`losslesscut-bin`) | `standalone/default.nix` |
| `logi-options-plus` | `logi-options+` の別名のため不要 | — |
| `slack` | home-manager nixpkg | `standalone/default.nix` |
| `tableplus` | nix-darwin cask | `modules/default.nix` |
| `visual-studio-code` | home-manager `programs.vscode` | `modules/vscode/` |
| `obs` | home-manager nixpkg (`obs-studio`) | `standalone/default.nix` |
| `rectangle` | home-manager nixpkg | `standalone/default.nix` |
| `vnc-viewer` | home-manager nixpkg (`realvnc-vnc-viewer`) | `standalone/default.nix` |
| `betterdisplay` | home-manager nixpkg | `standalone/default.nix` |

---

---

## Formulae — 管理済み（今回追加）

| formula | nixpkgs 属性 | dotfiles の記述箇所 |
|---------|-------------|-------------------|
| `fastly` | `pkgs.fastly` | `standalone/default.nix` |
| `infracost` | `pkgs.infracost` | `standalone/default.nix` |
| `tbls` | `pkgs.tbls` | `standalone/default.nix` |
| `lsix` | `pkgs.lsix` | `standalone/default.nix` |
| `presenterm` | `pkgs.presenterm` | `standalone/default.nix` |
| `typos-cli` | `pkgs.typos` | `standalone/default.nix` |
| `agg` | `pkgs.agg` | `standalone/default.nix` |
| `alp` | `pkgs.alp` | `standalone/default.nix` |
| `colima` | `pkgs.colima` | `standalone/default.nix` |
| `lazygit` | `pkgs.lazygit` | `modules/git/default.nix` |
| `htop` | `pkgs.htop` | `standalone/default.nix` |
| `watchexec` | `pkgs.watchexec` | `standalone/default.nix` |

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
