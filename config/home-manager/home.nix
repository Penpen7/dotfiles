{ config, pkgs, ... }:

let
  powerline-mem-segment = pkgs.python3Packages.buildPythonPackage rec {
    pname = "powerline-mem-segment";
    version = "2.4.1";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-KcZr7pxHkk6mL97c2hxeNoZzG2vKFMzamT8R8g7/BxQ=";
    };
    build-system = [ pkgs.python3Packages.setuptools ];
    propagatedBuildInputs = with pkgs.python3Packages; [ powerline psutil ];
    doCheck = false;
  };

  powerline-wttr = pkgs.python3Packages.buildPythonPackage rec {
    pname = "powerline-wttr";
    version = "0.1";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/e9/23/2f3a2500d2a3df5bd6c9750a175379f4f65b0edd63173c89e69dfa35781d/powerline_wttr-0.1-py3-none-any.whl";
      hash = "sha256-qSt/RTgzM+ISamiyXsuOrCXtEB9emg39itCMIpTKoTI=";
    };
    propagatedBuildInputs = with pkgs.python3Packages; [ powerline requests ];
    doCheck = false;
  };

  powerlinePython = pkgs.python3.withPackages (ps: [
    ps.powerline
    powerline-mem-segment
    powerline-wttr
  ]);
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "naoki";
  home.homeDirectory = "/Users/naoki";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true; # terraform など unfree パッケージを許可

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Nix
    nixfmt       # Nix コードのフォーマッタ

    # シェル・ターミナル
    zsh          # Zシェル
    zellij       # セッション管理対応のターミナルマルチプレクサ
    yazi         # Rust 製の高速ターミナルファイルマネージャ
    tmux              # ターミナルマルチプレクサ
    tmux-mem-cpu-load # tmux-powerline から呼ばれる CPU/メモリ表示バイナリ

    # エディタ
    neovim       # モダンな Vim 派生テキストエディタ
    emacs        # 高度に拡張可能なテキストエディタ
    helix        # モダンなターミナルテキストエディタ (Vim 系)
    vscode       # Microsoft 製のコードエディタ (unfree)

    # Git 関連
    git          # バージョン管理システム
    git-secrets  # シークレット情報の git コミットを防止
    delta        # git diff のシンタックスハイライト表示 (git-delta)
    tig          # git ログのターミナル UI ブラウザ
    gh           # GitHub CLI
    ghq          # リポジトリの一元管理ツール
    hub          # GitHub を CLI から操作する拡張コマンド

    # ビルド・コンパイル
    cmake        # クロスプラットフォームのビルドシステム生成ツール
    gcc          # GNU Cコンパイラコレクション
    zig          # Zig 言語のコンパイラ・ビルドツール
    protobuf     # Protocol Buffers コードジェネレータ (protoc)

    # 言語・インタープリタ
    go           # Go 言語コンパイラ・ツールチェーン
    deno         # セキュアな JavaScript / TypeScript ランタイム
    uv           # 高速な Python パッケージマネージャ
    lua          # Lua 言語インタープリタ
    nodejs_24    # Node.js JavaScript ランタイム (バージョン 24)
    llvm
    bash-language-server

    # インフラ
    terraform    # インフラのコードによる定義・プロビジョニング (unfree)
    terraform-ls # Terraform 用 Language Server
    terraformer  # 既存インフラから Terraform コードを逆生成
    awscli2      # AWS CLI v2
    cloudflared  # Cloudflare Tunnel クライアント
    supabase-cli # Supabase CLI

    # ネットワーク・セキュリティ
    gnupg        # GPG 暗号化・署名ツール
    nmap         # ネットワークスキャン・ポート探索
    sshuttle     # SSH 経由の透過的プロキシ (VPN 代替)
    rclone       # クラウドストレージとのファイル同期
    arp-scan     # ARP を使ったネットワークスキャン

    # データ処理・変換
    dsq          # CSV / JSON 等のファイルに SQL クエリを実行
    sqlite       # 軽量組み込み SQL データベース (sqlite3 CLI)
    jq           # JSON の加工・フィルタリング
    jo           # JSON オブジェクトをコマンドラインから生成
    pandoc       # ドキュメント形式の相互変換 (Markdown, PDF, Word 等)
    ghostscript  # PostScript / PDF の変換・レンダリング
    qpdf         # PDF の変換・分割・結合・検査
    tesseract    # OCR エンジン（画像からテキスト抽出）
    typst        # マークアップベースの組版・PDF 生成
    imagemagick  # 画像の変換・編集・加工
    ffmpeg       # 動画・音声のエンコード・変換

    # フォーマット・Lint
    shellcheck   # シェルスクリプトの静的解析・Lint
    shfmt        # シェルスクリプトのフォーマッタ
    yamlfmt      # YAML ファイルのフォーマッタ
    actionlint   # GitHub Actions ワークフローの Lint
    golangci-lint            # Go の統合 Lint ツール
    golangci-lint-langserver # golangci-lint の Language Server
    gotools                  # goimports 等の Go 公式補助ツール群
    (lib.hiPrio gopls)       # Go 公式 Language Server (gotools と modernize が競合するため優先度を上げる)

    # システム情報・監視
    fastfetch    # システム情報をターミナルに高速表示
    pv           # パイプのデータ転送量・速度を可視化
    procps       # watch コマンドを含むプロセス管理ツール群
    watchman     # ファイル変更を監視してアクションをトリガー

    # ファイル・テキスト操作
    ripgrep      # 高速な grep 代替ツール (rg)
    bat          # シンタックスハイライト付き cat 代替
    eza          # モダンな ls 代替 (カラー表示・アイコン対応)
    fzf          # コマンドラインのファジーファインダー
    tree         # ディレクトリ構造をツリー表示
    coreutils    # GNU コアユーティリティ群
    wget         # HTTP / FTP ファイルダウンロード
    nkf          # 日本語文字コード変換ツール
    gnuplot      # グラフ描画ツール
    graphviz     # DOT 言語からグラフを描画・出力
    grex         # サンプル文字列から正規表現を自動生成

    # 圧縮・展開
    lz4          # 高速な圧縮・展開ツール
    xz           # xz / LZMA 形式の圧縮・展開
    zstd         # Zstandard 高速圧縮・展開
    _7zz        # 7-Zip 形式を含む多形式の圧縮・展開 (sevenzip)

    # ターミナル表示・ユーティリティ
    mdcat        # Markdown をターミナルにレンダリング表示
    viu          # ターミナルで画像を表示
    mp3val       # MP3 ファイルの検証・修復
    tree-sitter  # インクリメンタル構文解析ライブラリ (CLI 付属)
    z3           # Microsoft 製オープンソース定理証明器
    bottom
    # subversion   # Apache SVN バージョン管理システム

    # タスク・自動化
    go-task      # Makefile 代替のタスクランナー (task コマンド)
    ansible      # サーバー構成管理・自動化ツール
    asciinema    # ターミナル操作の録画・共有ツール

    # Powerline
    powerlinePython   # powerline-status + powerline-mem-segment + powerline-wttr

    # macOS 連携
    mas               # Mac App Store を CLI から操作 (macOS 専用)
    terminal-notifier # macOS の通知センターに CLI から通知送信 (macOS 専用)

    # GUI アプリ (nixpkgs)
    alacritty         # GPU アクセラレーション対応のターミナルエミュレータ
    audacity          # オーディオ編集・録音ツール
    brave             # プライバシー重視のウェブブラウザ (unfree)
    chromedriver      # Chrome ブラウザの WebDriver (Selenium 等)
    cool-retro-term   # レトロ風ターミナルエミュレータ
    flutter           # クロスプラットフォーム UI フレームワーク (unfree)
    google-chrome     # Google Chrome ウェブブラウザ (unfree)
    iterm2            # macOS 専用の高機能ターミナルエミュレータ (unfree) ← cask: iterm2
    keycastr          # キー入力を画面に表示するツール ← cask: keycastr
    kitty             # GPU アクセラレーション対応のターミナルエミュレータ
    slack             # チームコミュニケーションツール (unfree)
    vagrant           # 仮想開発環境の構築・管理ツール
    skimpdf           # PDF ビューア・注釈ツール (unfree)
    realvnc-vnc-viewer # RealVNC リモートデスクトップクライアント (unfree)
    #warp-terminal     # AI 統合ターミナルエミュレータ ← cask: warp
    wireshark         # ネットワークプロトコルアナライザ (Qt GUI) ← cask: wireshark
    zoom-us           # ビデオ会議ツール (unfree)

    # 開発補助 (nixpkgs へ移行)
    github-copilot-cli # GitHub Copilot CLI ← cask: copilot-cli
    atlas # DBスキーマ管理ツール (バイナリ配布のため別途インストール推奨)
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".zshrc".source = ../zsh/.zshrc;
    ".zshenv".source = ../zsh/.zshenv;

    ".gitconfig".source = ../git/gitconfig;
    ".tigrc".source = ../tig/.tigrc;

    ".hyper.js".source = ../hyper/.hyper.js;
    ".p10k.zsh".source = ../powerlevel/.p10k.zsh;

    ".ideavimrc".source = ../intellij/.ideavimrc;

  };

  xdg.configFile = {
      "nvim/init.lua".source = ../nvim/init.lua;
      "nvim/lua" = { source = ../nvim/lua; recursive = true; };
      "nvim/coc-settings.json".source = ../nvim/coc-settings.json;
      "claude/settings.json".source = ../claude/settings.json;
      "tmux-powerline" = { source = ../tmux-powerline; recursive = true; };
      "zellij/config.kdl".source = ../zellij/config.kdl;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/naoki/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      open
      resurrect
      battery
      pain-control
      tmux-powerline
    ];
    extraConfig = builtins.readFile ../tmux/.tmux.conf;
  };

}
