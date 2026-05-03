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

  # nixpkgs より新しい tmux プラグイン (GitHub 最新版へ上書き)
  tmuxPluginOpen = pkgs.tmuxPlugins.open.overrideAttrs (_: {
    version = "unstable-2022-08-22";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo  = "tmux-open";
      rev   = "763d0a852e6703ce0f5090a508330012a7e6788e";
      hash  = "sha256-Thii7D21MKodtjn/MzMjOGbJX8BwnS+fQqAtYv8CjPc=";
    };
  });
  tmuxPluginResurrect = pkgs.tmuxPlugins.resurrect.overrideAttrs (_: {
    version = "unstable-2023-03-06";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo  = "tmux-resurrect";
      rev   = "cff343cf9e81983d3da0c8562b01616f12e8d548";
      hash  = "sha256-FcSjYyWjXM1B+WmiK2bqUNJYtH7sJBUsY2IjSur5TjY=";
    };
    # git submodule (lib/tmux-test) 未取得によるリンク切れを除去
    postInstall = ''
      rm -rf $out/share/tmux-plugins/resurrect/tests \
             $out/share/tmux-plugins/resurrect/run_tests
    '';
  });
  tmuxPluginBattery = pkgs.tmuxPlugins.battery.overrideAttrs (_: {
    version = "unstable-2025-12-30";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo  = "tmux-battery";
      rev   = "43832651ede43f54dcf0588727c1957fe648d57d";
      hash  = "sha256-kyUrJdraDDye8WEBP2RgHN7kHmafToYtLmrMJ9u0f+0=";
    };
  });
  tmuxPluginPainControl = pkgs.tmuxPlugins."pain-control".overrideAttrs (_: {
    version = "unstable-2021-08-09";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo  = "tmux-pain-control";
      rev   = "32b760f6652f2305dfef0acd444afc311cf5c077";
      hash  = "sha256-2VI9w7Naj9OHF3iuV63Ij4QcYhbrtngyJ3GpeyzIKxs=";
    };
  });
  tmuxPluginPowerline = pkgs.tmuxPlugins.tmux-powerline.overrideAttrs (_: {
    version = "unstable-2026-02-09";
    src = pkgs.fetchFromGitHub {
      owner = "erikw";
      repo  = "tmux-powerline";
      rev   = "d70011158dc389070d6ed7a67b65367206b6ddec";
      hash  = "sha256-0ibtd1gTyr8hJDBsAfmgH3qr0zC0o2Fn0tjN/S+zxgA=";
    };
  });

  nvimFernRendererNerdfont = pkgs.vimUtils.buildVimPlugin {
    name = "fern-renderer-nerdfont.vim";
    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo  = "fern-renderer-nerdfont.vim";
      rev   = "325629c68eb543229715b68920fbcb92b206beb6";
      hash  = "sha256-bcFIyPHxdckmmEGSCr9F5hLGTENF+KgRoz2BK49rGv4=";
    };
  };
  nvimFernGitStatus = pkgs.vimUtils.buildVimPlugin {
    name = "fern-git-status.vim";
    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo  = "fern-git-status.vim";
      rev   = "151336335d3b6975153dad77e60049ca7111da8e";
      hash  = "sha256-9N+T/MB+4hKcxoKRwY8F7iwmTsMtNmHCHiVZfcsADcc=";
    };
  };
  nvimNerdfont = pkgs.vimUtils.buildVimPlugin {
    name = "nerdfont.vim";
    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo  = "nerdfont.vim";
      rev   = "cc50782ee9580fc70b659cf1ebd55229d94b37ab";
      hash  = "sha256-Eb79rGmFBidT9hdjYZqyxwXynpsipfZopJFabYHimys=";
    };
  };
  nvimGlyphPalette = pkgs.vimUtils.buildVimPlugin {
    name = "glyph-palette.vim";
    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo  = "glyph-palette.vim";
      rev   = "675f0ad64e2c4b823bffc1907d469deefaf6e3bd";
      hash  = "sha256-y3pykCEynYGvjrQKzcYJsiuVOci+y2SNh0ZOg2xV8yU=";
    };
  };
  nvimTigExplorer = pkgs.vimUtils.buildVimPlugin {
    name = "tig-explorer.vim";
    src = pkgs.fetchFromGitHub {
      owner = "iberianpig";
      repo  = "tig-explorer.vim";
      rev   = "c134fa56ad46a5ff78fcb87c8e10c8cf8ec85b0c";
      hash  = "sha256-X+++SPMYTNl3/waFiJ0ZAElZa8+r/XqlV56BFegwBdM=";
    };
  };
  nvimTelescopeCoAuthor = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-co-author.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Penpen7";
      repo  = "telescope-co-author.nvim";
      rev   = "e0eefc8474230ccdab8a572f099547c2104c388e";
      hash  = "sha256-nONZmtOH1l8BMhK0zxWFVQRFp/fnsDxWEZrs7pu+rZc=";
    };
    dependencies = [ pkgs.vimPlugins.telescope-nvim pkgs.vimPlugins.plenary-nvim ];
  };
  nvimVimRestConsole = pkgs.vimUtils.buildVimPlugin {
    name = "vim-rest-console";
    src = pkgs.fetchFromGitHub {
      owner = "diepm";
      repo  = "vim-rest-console";
      rev   = "7b407f47185468d1b57a8bd71cdd66c9a99359b2";
      hash  = "sha256-Us7LLK/GJsFyIIROGn4y0k8c3yz+Y/X+WWwHcRqL+PQ=";
    };
  };
  nvimSwaggerPreview = pkgs.vimUtils.buildVimPlugin {
    name = "swagger-preview.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "vinnymeller";
      repo  = "swagger-preview.nvim";
      rev   = "42999dd6ad0bbb3e6ca5e857f3fc3c12de014110";
      hash  = "sha256-0PmasvfQKBKtqYOoY/CCqVMuku2zSeex3qGK8KVqPE0=";
    };
  };
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
    ".zshrc".source = pkgs.replaceVars ../zsh/.zshrc {
      zinit                     = "${pkgs.zinit}/share/zinit";
      zshPowerlevel10k          = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      zshAutosuggestions        = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      zshFastSyntaxHighlighting = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
      zshCompletions            = "${pkgs.zsh-completions}/share/zsh/site-functions";
    };
    ".zshenv".source = ../zsh/.zshenv;

    ".gitconfig".source = ../git/gitconfig;
    ".tigrc".source = ../tig/.tigrc;

  ".tmux.conf".source = pkgs.replaceVars ../tmux/.tmux.conf {
      TMUX_PLUGIN_YANK             = "${pkgs.tmuxPlugins.yank.rtp}";
      TMUX_PLUGIN_OPEN             = "${tmuxPluginOpen.rtp}";
      TMUX_PLUGIN_PAIN_CONTROL     = "${tmuxPluginPainControl.rtp}";
      TMUX_PLUGIN_RESURRECT        = "${tmuxPluginResurrect.rtp}";
      TMUX_PLUGIN_BATTERY          = "${tmuxPluginBattery.rtp}";
      TMUX_PLUGIN_POWERLINE        = "${tmuxPluginPowerline.rtp}";
    };

    ".hyper.js".source = ../hyper/.hyper.js;
    ".p10k.zsh".source = ../powerlevel/.p10k.zsh;

    ".ideavimrc".source = ../intellij/.ideavimrc;

    "Library/Application Support/Code/User/settings.json".source = ../vscode/settings.json;
    "Library/Application Support/Code/User/keybindings.json".source = ../vscode/keybindings.json;

  };

  xdg.configFile = {
      "nvim/init.lua".source = ../nvim/init.lua;
      "nvim/coc-settings.json".source = ../nvim/coc-settings.json;

      "nvim/lua/core/core.lua".source        = ../nvim/lua/core/core.lua;
      "nvim/lua/core/key_mapping.lua".source = ../nvim/lua/core/key_mapping.lua;
      "nvim/lua/core/lazy/ft.lua".source     = ../nvim/lua/core/lazy/ft.lua;

      "nvim/lua/core/lazy.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy.lua {
        lazyNvim = pkgs.vimPlugins.lazy-nvim;
      };

      "nvim/lua/core/lazy/appearance.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/appearance.lua {
        nordNvim        = pkgs.vimPlugins.nord-nvim;
        lualineNvim     = pkgs.vimPlugins.lualine-nvim;
        nvimWebDevicons = pkgs.vimPlugins.nvim-web-devicons;
        lspProgressNvim = pkgs.vimPlugins.lsp-progress-nvim;
      };

      "nvim/lua/core/lazy/ui.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ui.lua {
        fernVim              = pkgs.vimPlugins.vim-fern;
        fernRendererNerdfont = nvimFernRendererNerdfont;
        fernGitStatus        = nvimFernGitStatus;
        nerdfont             = nvimNerdfont;
        nvimWebDevicons      = pkgs.vimPlugins.nvim-web-devicons;
        glyphPalette         = nvimGlyphPalette;
        vimDevicons          = pkgs.vimPlugins.vim-devicons;
        bufferlineNvim       = pkgs.vimPlugins.bufferline-nvim;
        undotree             = pkgs.vimPlugins.undotree;
        calendarVim          = pkgs.vimPlugins.calendar-vim;
        vimTest              = pkgs.vimPlugins.vim-test;
        openBrowserVim       = pkgs.vimPlugins.open-browser-vim;
        whichKeyNvim         = pkgs.vimPlugins.which-key-nvim;
        vimHighlightedyank   = pkgs.vimPlugins.vim-highlightedyank;
        bcloseVim            = pkgs.vimPlugins.bclose-vim;
        hopNvim              = pkgs.vimPlugins.hop-nvim;
      };

      "nvim/lua/core/lazy/treesitter.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/treesitter.lua {
        aerialNvim            = pkgs.vimPlugins.aerial-nvim;
        nvimWebDevicons       = pkgs.vimPlugins.nvim-web-devicons;
        nvimTreesitter        = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        rainbowDelimitersNvim = pkgs.vimPlugins.rainbow-delimiters-nvim;
        indentBlanklineNvim   = pkgs.vimPlugins.indent-blankline-nvim;
      };

      "nvim/lua/core/lazy/lsp.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/lsp.lua {
        cocNvim         = pkgs.vimPlugins.coc-nvim;
        cocClangd       = pkgs.vimPlugins.coc-clangd;
        cocCss          = pkgs.vimPlugins.coc-css;
        cocDiagnostic   = pkgs.vimPlugins.coc-diagnostic;
        cocJson         = pkgs.vimPlugins.coc-json;
        cocLua          = pkgs.vimPlugins.coc-lua;
        cocPairs        = pkgs.vimPlugins.coc-pairs;
        cocRustAnalyzer = pkgs.vimPlugins.coc-rust-analyzer;
        cocSnippets     = pkgs.vimPlugins.coc-snippets;
        cocToml         = pkgs.vimPlugins.coc-toml;
        cocYaml         = pkgs.vimPlugins.coc-yaml;
      };

      "nvim/lua/core/lazy/edit.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/edit.lua {
        vimEndwise      = pkgs.vimPlugins.vim-endwise;
        vimSurround     = pkgs.vimPlugins.vim-surround;
        vimFugitive     = pkgs.vimPlugins.vim-fugitive;
        tcommentVim     = pkgs.vimPlugins.tcomment_vim;
        tabular         = pkgs.vimPlugins.tabular;
        nvimAutopairs   = pkgs.vimPlugins.nvim-autopairs;
        copilotLua      = pkgs.vimPlugins.copilot-lua;
        copilotChatNvim = pkgs.vimPlugins.CopilotChat-nvim;
        plenaryNvim     = pkgs.vimPlugins.plenary-nvim;
        snacksNvim      = pkgs.vimPlugins.snacks-nvim;
        claudecodeNvim  = pkgs.vimPlugins.claudecode-nvim;
        avanteNvim      = pkgs.vimPlugins.avante-nvim;
        dressingNvim    = pkgs.vimPlugins.dressing-nvim;
        nuiNvim         = pkgs.vimPlugins.nui-nvim;
        imgClipNvim     = pkgs.vimPlugins.img-clip-nvim;
        vimTableMode    = pkgs.vimPlugins.vim-table-mode;
      };

      "nvim/lua/core/lazy/git.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/git.lua {
        tigExplorer  = nvimTigExplorer;
        gitsignsNvim = pkgs.vimPlugins.gitsigns-nvim;
      };

      "nvim/lua/core/lazy/fzf.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/fzf.lua {
        fzfWrapper        = pkgs.vimPlugins.fzf-wrapper;
        telescopeNvim     = pkgs.vimPlugins.telescope-nvim;
        plenaryNvim       = pkgs.vimPlugins.plenary-nvim;
        telescopeCocNvim  = pkgs.vimPlugins.telescope-coc-nvim;
        telescopeCoAuthor = nvimTelescopeCoAuthor;
      };

      "nvim/lua/core/lazy/utils.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/utils.lua {
        vimStartuptime = pkgs.vimPlugins.vim-startuptime;
      };

      "nvim/lua/core/lazy/ft/html.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/html.lua {
        emmetVim = pkgs.vimPlugins.emmet-vim;
      };
      "nvim/lua/core/lazy/ft/markdown.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/markdown.lua {
        markdownPreviewNvim = pkgs.vimPlugins.markdown-preview-nvim;
        vimMarkdown         = pkgs.vimPlugins.vim-markdown;
      };
      "nvim/lua/core/lazy/ft/plantuml.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/plantuml.lua {
        plantumlSyntax = pkgs.vimPlugins.plantuml-syntax;
      };
      "nvim/lua/core/lazy/ft/rest.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/rest.lua {
        vimRestConsole = nvimVimRestConsole;
      };
      "nvim/lua/core/lazy/ft/swagger.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/swagger.lua {
        swaggerPreview = nvimSwaggerPreview;
      };
      "nvim/lua/core/lazy/ft/terraform.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/terraform.lua {
        vimTerraform = pkgs.vimPlugins.vim-terraform;
      };
      "nvim/lua/core/lazy/ft/ts.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/ft/ts.lua {
        nvimTsAutotag = pkgs.vimPlugins.nvim-ts-autotag;
      };
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

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      asvetliakov.vscode-neovim
      github.copilot-chat
      golang.go
      hashicorp.terraform
      jdinhlife.gruvbox
      jebbs.plantuml
      mhutchie.git-graph
      ms-azuretools.vscode-containers
      ms-azuretools.vscode-docker
      ms-ceintl.vscode-language-pack-ja
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-python.vscode-python-envs
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vsliveshare.vsliveshare
      ms-vsliveshare.vsliveshare-audio
      vscodevim.vim
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
