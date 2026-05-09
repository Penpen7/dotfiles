# home.nix 分割・プロファイル対応 実装計画

---

## 現状の確認

`home.nix` と `configuration.nix` はそれぞれ 1 ファイルに全設定がまとまっている。
設定が増えるにつれて見通しが悪くなり、仕事用・個人用で環境を使い分けることもできない。

これを次の 2 点で改善する。

- **ファイル分割**: 関心ごとにファイルとディレクトリを分け、管理しやすくする
- **プロファイル対応**: 共通モジュールに個人専用モジュールを追加して読み込める構造にする

---

## Nix モジュールシステムの仕組み

分割が成立する理由を先に押さえておく。

`flake.nix` の `modules` は現在 1 ファイルを指すリストになっている。

```nix
modules = [ ./config/home-manager/home.nix ];
```

リストに複数のファイルを並べると、それぞれに同じ引数が渡され、同じキーへの宣言は
自動的にマージされる。リスト型は結合され、attrset 型は深くマージされる。

```
modules = [ A.nix  B.nix  C.nix ]
             ↓       ↓      ↓
          home.packages が自動的に結合される
```

この性質があるため、設定を複数ファイルに分割しても動作は変わらない。
home-manager と nix-darwin はどちらも同じ Nix モジュールシステムを使っており、
同じアプローチでプロファイル分割に対応できる。

---

## ファイルの配置方針

現在の設定ファイルは `../nvim/init.lua` のように相対パスで参照している。
モジュール分割後にパスが深くなると `../../../../nvim/init.lua` のように長くなる。

nix モジュールとその設定ファイルを同じディレクトリに置くと参照が `./init.lua` になる。

```
変更前: config/home-manager/modules/common/nvim.nix  →  ../../../nvim/init.lua
変更後: config/home-manager/modules/common/nvim/default.nix  →  ./init.lua
```

---

## 分割後のディレクトリ構成

すべての設定定義は `modules/` に置く。
`profile/` は `modules/` 内のモジュールを import するだけで、設定は書かない。

```
config/
  home-manager/
    modules/
      default.nix        ← home.username / imports をまとめる
      standalone/
        default.nix      ← home.packages (共通・ツール非依存)
      discord/
        default.nix      ← discord (personal のみ)
      nvim/
        default.nix
        init.lua
        lua/...
      zsh/
        default.nix
        .zshrc  .zshenv
      git/
        default.nix
        gitconfig
      tmux/
        default.nix
        .tmux.conf  powerline/
      vscode/
        default.nix
        settings.json  keybindings.json
      zellij/
        default.nix
        config.kdl
      claude/
        default.nix
        settings.json
      hyper/
        default.nix
        .hyper.js
      intellij/
        default.nix
        .ideavimrc
      powerlevel/
        default.nix
        .p10k.zsh
      tig/
        default.nix
        .tigrc
      brave/
        default.nix
      chrome/
        default.nix
      go/
        default.nix
      rust/
        default.nix
      flutter/
        default.nix
    profile/
      work/
        default.nix      ← ../../modules のみ import (将来の拡張用)
      personal/
        default.nix      ← ../../modules + personal モジュールを import
  nix-darwin/
    modules/
      default.nix              ← システム設定・フォント・セキュリティ・シェル設定
      nas.nix          ← synology-drive, tailscale-app, Synology Image Assistant Extension (personal のみ)
      monitor_wifi.nix         ← iWifi, Ultra Wifi, WiFi Explorer (personal のみ)
      line.nix          ← LINE (personal のみ)
      media.nix        ← iMovie, Kindle (personal のみ)
      dtm.nix          ← GarageBand, Logic Pro, izotope-product-portal (personal のみ)
      dj.nix           ← rekordbox (personal のみ)
      game.nix         ← minecraft (personal のみ)
    profile/
      personal/
        default.nix      ← ../../modules + personal モジュールを import
    profile/
      work/
        default.nix      ← ../../modules のみ import (将来の拡張用)
```

---

## プロファイルの仕組み

`homeConfigurations` と `darwinConfigurations` に `work` / `personal` の 2 エントリを定義する。
username はプロファイルごとに `extraSpecialArgs` / `specialArgs` で個別に渡す。

```nix
# flake.nix (変更後・抜粋)
let
  system = "aarch64-darwin";
  pkgs   = import nixpkgs { ... };
in
{
  homeConfigurations = {
    "work" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { username = "naoki"; };
      modules = [ ./config/home-manager/profile/work ];
    };
    "personal" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { username = "naoki"; };
      modules = [ ./config/home-manager/profile/personal ];
    };
  };
  darwinConfigurations = {
    "work" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; username = "naoki"; };
      modules = [ ./config/nix-darwin/profile/work ];
    };
    "personal" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; username = "naoki"; };
      modules = [ ./config/nix-darwin/profile/personal ];
    };
  };
}
```

---

## プロファイルごとのモジュール

personal 専用の設定はすべて `modules/` に置き、`profile/personal/default.nix` は import するだけ。

- home-manager: `modules/discord/default.nix` に discord
- nix-darwin: `modules/nas.nix` / `modules/monitor_wifi.nix` / `modules/line.nix` / `modules/media.nix` / `modules/dtm.nix` / `modules/dj.nix` / `modules/game.nix` に個人用 casks / masApps

---

## プロファイルの切り替え方

```bash
# 仕事用
home-manager switch --flake .#work
darwin-rebuild switch --flake .#work

# 個人用
home-manager switch --flake .#personal
darwin-rebuild switch --flake .#personal
```

---

## 実装ステップ

### 1. 設定ファイルを `config/home-manager/modules/` 配下に移動する

| 移動先 | 移動元 |
|---|---|
| `modules/nvim/` | `config/nvim/` 以下をすべて |
| `modules/zsh/` | `config/zsh/.zshrc`, `.zshenv` |
| `modules/git/` | `config/git/gitconfig` |
| `modules/tmux/` | `config/tmux/.tmux.conf`, `config/tmux-powerline/` |
| `modules/vscode/` | `config/vscode/settings.json`, `keybindings.json` |
| `modules/zellij/` | `config/zellij/config.kdl` |
| `modules/claude/` | `config/claude/settings.json` |
| `modules/hyper/` | `config/hyper/.hyper.js` |
| `modules/intellij/` | `config/intellij/.ideavimrc` |
| `modules/powerlevel/` | `config/powerlevel/.p10k.zsh` |
| `modules/tig/` | `config/tig/.tigrc` |

### 2. 各ツールの `default.nix` を新規作成する

`home.nix` から対応するエントリを切り出し、パスを `./` 基準に書き直す。
以下に代表例を示す。

```nix
# modules/zsh/default.nix
{ pkgs, ... }:
{
  home.file = {
    ".zshrc".source = pkgs.replaceVars ./.zshrc {
      zinit                     = "${pkgs.zinit}/share/zinit";
      zshPowerlevel10k          = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      zshAutosuggestions        = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      zshFastSyntaxHighlighting = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
      zshCompletions            = "${pkgs.zsh-completions}/share/zsh/site-functions";
    };
    ".zshenv".source = ./.zshenv;
  };
}
```

```nix
# modules/nvim/default.nix
{ pkgs, ... }:
let
  tsParserDirs = pkgs.lib.pipe
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: builtins.attrValues p)).dependencies
    [ (map toString) (builtins.concatStringsSep ",") ];
in
{
  home.packages = with pkgs; [
    neovim       # エディタ本体
    tree-sitter  # nvim-treesitter の CLI (nvim 専用)
  ];
  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    "nvim/lua/core/core.lua".source = ./lua/core/core.lua;
    # ... 以下同様
  };
}
```

```nix
# modules/tmux/default.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux              # ターミナルマルチプレクサ
    tmux-mem-cpu-load # tmux-powerline から呼ばれる CPU/メモリ表示バイナリ
    powerlinePython   # powerline-status + powerline-mem-segment + powerline-wttr
  ];
  home.file = {
    ".tmux.conf".source = pkgs.replaceVars ./.tmux.conf { ... };
  };
  xdg.configFile = {
    "tmux-powerline" = { source = ./powerline; recursive = true; };
  };
}
```

各ツールと切り出す内容の対応:

ツール固有のパッケージはそのツールの `default.nix` 内の `home.packages` に定義する。
汎用パッケージは `modules/standalone/default.nix` の `home.packages` にまとめて置く。

| default.nix | home.packages | 設定ファイル |
|---|---|---|
| `nvim/` | `neovim`, `tree-sitter` | `xdg.configFile` の nvim エントリ全体 + `tsParserDirs` |
| `zsh/` | `zsh` | `home.file` の `.zshrc`, `.zshenv` |
| `git/` | `git`, `git-secrets`, `delta`, `gh`, `ghq`, `hub` | `home.file` の `.gitconfig` |
| `tmux/` | `tmux`, `tmux-mem-cpu-load`, `powerlinePython` | `home.file` の `.tmux.conf` + `xdg.configFile` の `tmux-powerline` |
| `vscode/` | — | `programs.vscode` + `home.file` の vscode エントリ |
| `zellij/` | `zellij` | `xdg.configFile` の `zellij/config.kdl` |
| `claude/` | — | `xdg.configFile` の `claude/settings.json` |
| `hyper/` | — | `home.file` の `.hyper.js` |
| `intellij/` | — | `home.file` の `.ideavimrc` |
| `powerlevel/` | — | `home.file` の `.p10k.zsh` |
| `tig/` | `tig` | `home.file` の `.tigrc` |
| `brave/` | — | `programs.brave` |
| `chrome/` | — | `programs.google-chrome` |
| `go/` | `go`, `gopls`, `golangci-lint`, `golangci-lint-langserver`, `gotools` | — |
| `rust/` | `rust-bin` (rust-src, rust-analyzer) | — |
| `flutter/` | `flutter`, `chromedriver` | — |

### 3. `modules/standalone/default.nix` と `modules/default.nix` を作成する

```nix
# modules/standalone/default.nix
# ツール固有のパッケージは各ツールの default.nix に置く。
# ここには特定ツールに属さない汎用パッケージのみ列挙する。
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # エディタ (neovim → nvim/, emacs/helix はモジュールなし)
    emacs
    helix

    # シェル・ファイラ (zsh → zsh/, zellij → zellij/, tmux → tmux/ で管理)
    yazi

    # ビルド・コンパイル (rust → rust/, go → go/, flutter → flutter/ で管理)
    cmake
    gcc
    zig
    protobuf

    # 言語・インタープリタ (go → go/, rust → rust/, flutter → flutter/ で管理)
    deno
    uv
    lua
    nodejs_24
    llvm
    bash-language-server

    # インフラ
    terraform
    terraform-ls
    terraformer
    awscli2
    cloudflared
    supabase-cli
    ansible
    atlas

    # ネットワーク・セキュリティ
    gnupg
    nmap
    sshuttle
    rclone
    arp-scan

    # データ処理・変換
    dsq
    sqlite
    jq
    jo
    pandoc
    ghostscript
    qpdf
    tesseract
    typst
    imagemagick
    ffmpeg

    # フォーマット・Lint (golangci-lint 系と gopls は go/ で管理)
    shellcheck
    shfmt
    yamlfmt
    actionlint

    # システム情報・監視
    fastfetch
    pv
    procps
    watchman

    # ファイル・テキスト操作
    ripgrep
    bat
    eza
    fzf
    tree
    coreutils
    wget
    nkf
    gnuplot
    graphviz
    grex

    # 圧縮・展開
    lz4
    xz
    zstd
    _7zz

    # ターミナル表示・ユーティリティ
    mdcat
    viu
    mp3val
    z3
    bottom

    # タスク・自動化
    go-task

    # macOS 連携
    mas
    terminal-notifier

    # GUI アプリ (flutter, chromedriver は flutter/ で管理)
    alacritty
    audacity
    cool-retro-term
    geogebra
    iterm2
    keycastr
    kitty
    slack
    synology-drive-client
    vagrant
    skimpdf
    realvnc-vnc-viewer
    wireshark
    zoom-us
    github-copilot-cli
    asciinema
  ];
}
```

```nix
# modules/default.nix
{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./standalone
    ./nvim  ./zsh  ./git  ./tmux  ./vscode
    ./zellij  ./claude  ./hyper  ./intellij
    ./powerlevel  ./tig  ./brave  ./chrome
    ./go  ./rust  ./flutter
  ];
}
```

### 4. `profile/personal/` を作成する (home-manager)

discord 以外のパッケージはすべて `modules/standalone/default.nix` に置く。
ただしツール固有のパッケージはステップ2で各ツールの `default.nix` に移動済みのため除く
（ステップ2のテーブル参照）。

| パッケージ | modules/standalone | personal |
|---|---|---|
| yazi | o | |
| emacs / helix | o | |
| cmake / gcc / zig / protobuf | o | |
| deno / uv / lua / nodejs_24 / llvm / bash-language-server | o | |
| go / gopls / golangci-lint / golangci-lint-langserver / gotools | go/ | |
| rust-bin (stable, rust-src, rust-analyzer) | rust/ | |
| flutter / chromedriver | flutter/ | |
| terraform / terraform-ls / terraformer | o | |
| awscli2 / cloudflared / supabase-cli / ansible / atlas | o | |
| gnupg / nmap / sshuttle / rclone / arp-scan | o | |
| dsq / sqlite / jq / jo | o | |
| pandoc / ghostscript / qpdf / tesseract / typst / imagemagick / ffmpeg | o | |
| shellcheck / shfmt / yamlfmt / actionlint | o | |
| fastfetch / pv / procps / watchman | o | |
| ripgrep / bat / eza / fzf / tree / coreutils / wget | o | |
| nkf / gnuplot / graphviz / grex | o | |
| lz4 / xz / zstd / _7zz | o | |
| mdcat / viu / mp3val / z3 / bottom | o | |
| go-task | o | |
| mas / terminal-notifier | o | |
| alacritty / iterm2 / keycastr / kitty | o | |
| synology-drive-client / vagrant / skimpdf / realvnc-vnc-viewer / wireshark | o | |
| zoom-us / github-copilot-cli | o | |
| slack | o | |
| discord | | o |
| audacity / cool-retro-term / geogebra / asciinema | o | |

work と personal はそれぞれ profile に `default.nix` を持ち、import するだけで設定は書かない。
personal 専用の設定は `modules/` に定義し、`profile/personal/default.nix` からのみ import する。

```nix
# modules/discord/default.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [ discord ];
}
```

```nix
# profile/work/default.nix
{
  imports = [
    ../../modules  # 共通モジュール一式のみ
  ];
}
```

```nix
# profile/personal/default.nix
{
  imports = [
    ../../modules          # 共通モジュール一式
    ../../modules/discord  # personal のみ
  ];
}
```

### 5. nix-darwin の `modules/default.nix` と `profile/` を作成する

`modules/default.nix` に `configuration.nix` の共通部分を移す。
personal 列の casks / masApps を除くすべての casks / masApps を `modules/default.nix` に置く。

```nix
# nix-darwin/modules/default.nix
{ self, pkgs, username, ... }:
{
  fonts.packages = with pkgs; [ hackgen-font  hackgen-nf-font ];
  system = {
    stateVersion = "5.0";
    primaryUser = username;
    configurationRevision = self.rev or self.dirtyRev or null;
    defaults = {
      dock = { orientation = "left"; tilesize = 128; magnification = true;
               largesize = 79; autohide = false; };
      NSGlobalDomain = { KeyRepeat = 1; InitialKeyRepeat = 15;
                         "com.apple.swipescrolldirection" = false;
                         "com.apple.trackpad.forceClick" = false;
                         AppleEnableSwipeNavigateWithScrolls = false; };
      finder = { ShowPathbar = true; ShowStatusBar = true; };
      trackpad = { Clicking = true; TrackpadThreeFingerDrag = true; };
      CustomUserPreferences = { ... };
    };
  };
  homebrew = {
    enable = true;
    onActivation = { autoUpdate = true; upgrade = true; cleanup = "zap"; };
    casks = [ /* 下表の modules 列のもの */ ];
    masApps = { /* 下表の modules 列のもの */ };
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  environment.shells = [ "/bin/zsh" ];
  system.activationScripts.postActivation.text = '' ... '';
}
```

casks の振り分け:

| cask | modules | personal |
|---|---|---|
| adobe-acrobat-reader | o | |
| claude | o | |
| docker-desktop | o | |
| izotope-product-portal | | o (dtm.nix) |
| kap | o | |
| logi-options+ | o | |
| microsoft-auto-update | o | |
| microsoft-teams | o | |
| minecraft | | o (game.nix) |
| rekordbox | | o (dj.nix) |
| synology-drive | | o (nas.nix) |
| tableplus | o | |
| tailscale-app | | o (nas.nix) |
| virtualbox | o | |

masApps の振り分け:

| masApp | modules | personal |
|---|---|---|
| AmorphousDiskMark | o | |
| Dropover | o | |
| Elmedia Video Player | o | |
| GarageBand | | o (dtm.nix) |
| GeoGebra Classic 6 | o | |
| iMovie | | o (media.nix) |
| iWifi | | o (monitor_wifi.nix) |
| Keynote | o | |
| Kindle | | o (media.nix) |
| LINE | | o (line.nix) |
| Logic Pro | | o (dtm.nix) |
| Magnet | o | |
| Numbers | o | |
| Pages | o | |
| Parallels Desktop | o | |
| PicGIF Lite | o | |
| RunCat | o | |
| Skitch | o | |
| Synology Image Assistant Extension | | o (nas.nix) |
| Ultra Wifi | | o (monitor_wifi.nix) |
| WiFi Explorer | | o (monitor_wifi.nix) |
| Xcode | o | |

personal 列の casks / masApps はすべて `nix-darwin/modules/` に定義する。
`profile/personal/default.nix` は import するだけで設定は書かない。

```nix
# nix-darwin/modules/nas.nix
{ ... }:
{
  homebrew.casks = [ "synology-drive" "tailscale-app" ];
  homebrew.masApps = {
    "Synology Image Assistant Extension" = 1609306487;
  };
}
```

```nix
# nix-darwin/modules/monitor_wifi.nix
{ ... }:
{
  homebrew.masApps = {
    "iWifi"        = 1541907910;
    "Ultra Wifi"   = 1545885823;
    "WiFi Explorer" = 494803304;
  };
}
```

```nix
# nix-darwin/modules/line.nix
{ ... }:
{
  homebrew.masApps = {
    "LINE" = 539883307;
  };
}
```

```nix
# nix-darwin/modules/media.nix
{ ... }:
{
  homebrew.masApps = {
    "iMovie" = 408981434;
    "Kindle" = 302584613;
  };
}
```

```nix
# nix-darwin/modules/dtm.nix
{ ... }:
{
  homebrew.casks   = [ "izotope-product-portal" ];
  homebrew.masApps = { "GarageBand" = 682658836; "Logic Pro" = 634148309; };
}
```

```nix
# nix-darwin/modules/dj.nix
{ ... }:
{
  homebrew.casks = [ "rekordbox" ];
}
```

```nix
# nix-darwin/modules/game.nix
{ ... }:
{
  homebrew.casks = [ "minecraft" ];
}
```

```nix
# nix-darwin/profile/personal/default.nix
{
  imports = [
    ../../modules            # 共通モジュール一式
    ../../modules/nas.nix
    ../../modules/monitor_wifi.nix
    ../../modules/line.nix
    ../../modules/media.nix
    ../../modules/dtm.nix
    ../../modules/dj.nix
    ../../modules/game.nix
  ];
}
```

### 6. `flake.nix` を更新する

```nix
let
  system = "aarch64-darwin";
  pkgs   = import nixpkgs { ... };
in
{
  # username はプロファイルごとに個別指定
  homeConfigurations = {
    "work" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { username = "naoki"; };
      modules = [ ./config/home-manager/profile/work ];
    };
    "personal" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { username = "naoki"; };
      modules = [ ./config/home-manager/profile/personal ];
    };
  };
  darwinConfigurations = {
    "work" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; username = "naoki"; };
      modules = [ ./config/nix-darwin/profile/work ];
    };
    "personal" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; username = "naoki"; };
      modules = [ ./config/nix-darwin/profile/personal ];
    };
  };

  # nix fmt で Nix ファイルをフォーマットできるようにする
  formatter.aarch64-darwin = pkgs.nixfmt-rfc-style;
}
```

### 7. 不要になったファイルを削除する

- `config/home-manager/home.nix`
- `config/nix-darwin/configuration.nix`
- `config/` 直下の移動済みディレクトリ

### 8. 動作確認

```bash
home-manager switch --flake .#work
darwin-rebuild switch --flake .#work

home-manager switch --flake .#personal
darwin-rebuild switch --flake .#personal
```
