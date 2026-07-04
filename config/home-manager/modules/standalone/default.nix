{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix
    nixfmt # Nix コードのフォーマッタ
    nixd # Nix Language Server

    # シェル・ファイラ (zsh / zellij / tmux は各モジュールで管理)
    yazi # Rust 製の高速ターミナルファイルマネージャ

    # エディタ (neovim は nvim/ で管理)
    emacs # 高度に拡張可能なテキストエディタ
    helix # モダンなターミナルテキストエディタ (Vim 系)

    # ビルド・コンパイル (rust / go / flutter は各モジュールで管理)
    cmake # クロスプラットフォームのビルドシステム生成ツール
    gcc # GNU Cコンパイラコレクション
    zig # Zig 言語のコンパイラ・ビルドツール
    protobuf # Protocol Buffers コードジェネレータ (protoc)

    # 言語・インタープリタ (go / rust / flutter は各モジュールで管理)
    deno # セキュアな JavaScript / TypeScript ランタイム
    uv # 高速な Python パッケージマネージャ
    lua # Lua 言語インタープリタ
    nodejs_24 # Node.js JavaScript ランタイム (バージョン 24)
    llvm
    bash-language-server

    # インフラ
    terraform # インフラのコードによる定義・プロビジョニング (unfree)
    terraform-ls # Terraform 用 Language Server
    terraformer # 既存インフラから Terraform コードを逆生成
    awscli2 # AWS CLI v2
    supabase-cli # Supabase CLI
    ansible # サーバー構成管理・自動化ツール
    atlas # DBスキーマ管理ツール (バイナリ配布のため別途インストール推奨)
    colima # macOS 向けコンテナランタイム
    fastly # Fastly CDN CLI
    infracost # インフラコスト見積もり
    tbls # DB スキーマドキュメント生成

    # ネットワーク・セキュリティ
    gnupg # GPG 暗号化・署名ツール
    nmap # ネットワークスキャン・ポート探索
    sshuttle # SSH 経由の透過的プロキシ (VPN 代替)
    rclone # クラウドストレージとのファイル同期
    arp-scan # ARP を使ったネットワークスキャン

    # データ処理・変換
    dsq # CSV / JSON 等のファイルに SQL クエリを実行
    sqlite # 軽量組み込み SQL データベース (sqlite3 CLI)
    jq # JSON の加工・フィルタリング
    jo # JSON オブジェクトをコマンドラインから生成
    pandoc # ドキュメント形式の相互変換 (Markdown, PDF, Word 等)
    ghostscript # PostScript / PDF の変換・レンダリング
    qpdf # PDF の変換・分割・結合・検査
    tesseract # OCR エンジン（画像からテキスト抽出）
    typst # マークアップベースの組版・PDF 生成
    imagemagick # 画像の変換・編集・加工
    ffmpeg # 動画・音声のエンコード・変換

    # フォーマット・Lint (Go 系は go/ で管理)
    shellcheck # シェルスクリプトの静的解析・Lint
    shfmt # シェルスクリプトのフォーマッタ
    yamlfmt # YAML ファイルのフォーマッタ
    actionlint # GitHub Actions ワークフローの Lint

    # システム情報・監視
    fastfetch # システム情報をターミナルに高速表示
    pv # パイプのデータ転送量・速度を可視化
    procps # watch コマンドを含むプロセス管理ツール群
    # watchman # ファイル変更を監視してアクションをトリガー
    htop # インタラクティブなプロセスモニター
    watchexec # ファイル変更を監視してコマンドを実行

    # ファイル・テキスト操作
    ripgrep # 高速な grep 代替ツール (rg)
    bat # シンタックスハイライト付き cat 代替
    eza # モダンな ls 代替 (カラー表示・アイコン対応)
    fzf # コマンドラインのファジーファインダー
    tree # ディレクトリ構造をツリー表示
    coreutils # GNU コアユーティリティ群
    wget # HTTP / FTP ファイルダウンロード
    nkf # 日本語文字コード変換ツール
    gnuplot # グラフ描画ツール
    graphviz # DOT 言語からグラフを描画・出力
    grex # サンプル文字列から正規表現を自動生成
    lsix # ターミナルで画像をサムネイル表示
    typos # コードのスペルチェッカー
    alp # アクセスログプロファイラ
    presenterm # ターミナルプレゼンツール

    # 圧縮・展開
    lz4 # 高速な圧縮・展開ツール
    xz # xz / LZMA 形式の圧縮・展開
    zstd # Zstandard 高速圧縮・展開
    _7zz

    # ターミナル表示・ユーティリティ (tree-sitter は nvim/ で管理)
    mdcat # Markdown をターミナルにレンダリング表示
    viu # ターミナルで画像を表示
    mp3val # MP3 ファイルの検証・修復
    z3 # Microsoft 製オープンソース定理証明器
    bottom

    # タスク・自動化
    go-task # Makefile 代替のタスクランナー (task コマンド)
    asciinema # ターミナル操作の録画・共有ツール
    agg # asciinema 録画を GIF に変換
    takt # エージェントオーケストレーションフレームワーク

    # macOS 連携
    mas # Mac App Store を CLI から操作 (macOS 専用)
    terminal-notifier # macOS の通知センターに CLI から通知送信 (macOS 専用)

    # GUI アプリ
    alacritty # GPU アクセラレーション対応のターミナルエミュレータ
    audacity # オーディオ編集・録音ツール
    cool-retro-term # レトロ風ターミナルエミュレータ
    keycastr # キー入力を画面に表示するツール ← cask: keycastr
    kitty # GPU アクセラレーション対応のターミナルエミュレータ
    vagrant # 仮想開発環境の構築・管理ツール
    skimpdf # PDF ビューア・注釈ツール (unfree)
    wireshark # ネットワークプロトコルアナライザ (Qt GUI) ← cask: wireshark
    github-copilot-cli # GitHub Copilot CLI ← cask: copilot-cli
    code-cursor # AI コードエディタ (unfree)
    betterdisplay # ディスプレイ管理ツール (unfree)
    gst_all_1.gstreamer # GStreamer マルチメディアフレームワーク
    losslesscut-bin # 動画の無劣化カット・編集
    tableplus # リレーショナルDB用のGUIクライアント (pkgs/tableplus.nix でビルド番号固定)
  ];
}
