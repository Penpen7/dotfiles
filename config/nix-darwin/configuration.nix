{ self, pkgs, ... }:
let
  shellPath = "/bin/zsh";
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    hackgen-font      # cask: font-hackgen
    hackgen-nf-font   # cask: font-hackgen-nerd
  ];

  system = {
    stateVersion = "5.0";
    primaryUser = "naoki"; # darwin-rebuild を実行するユーザー
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      dock = {
        orientation = "left"; # Dockを画面左側に配置
        tilesize = 128;        # Dockアイコンのサイズ
        magnification = true;  # カーソルを乗せたときにアイコンを拡大
        largesize = 79;        # 拡大時のアイコンサイズ
        autohide = false;      # Dockを自動的に隠さない
      };

      NSGlobalDomain = {
        KeyRepeat = 2;         # キーリピート速度（小さいほど速い、デフォルト6）
        InitialKeyRepeat = 15; # キーリピート開始までの遅延（小さいほど速い、デフォルト25）
        "com.apple.swipescrolldirection" = false; # ナチュラルスクロールを無効化
        "com.apple.trackpad.forceClick" = false;  # Force Clickを無効化
        AppleEnableSwipeNavigateWithScrolls = false; # スワイプでの前後ページ移動を無効化
      };

      finder = {
        ShowStatusBar = false; # ステータスバーを非表示
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;    # darwin-rebuild 時に brew update を実行
      upgrade = true;       # 既存 cask を最新版にアップグレード
      cleanup = "zap";      # 宣言に無いアプリを削除 (アンインストール)
    };
    casks = [
      "adobe-acrobat-reader"  # Adobe Acrobat PDF リーダー
      "claude"                # Claude AI デスクトップアプリ
      "docker-desktop"        # Docker Desktop for Mac
      "hyper"                 # Electron ベースのターミナルエミュレータ
      "kap"                   # 画面録画ツール
      "logi-options+"         # Logicool デバイス管理アプリ
      "mactex"                # macOS 向け TeX Live ディストリビューション
      "microsoft-auto-update" # Microsoft アプリの自動更新ツール
      "microsoft-teams"       # Microsoft Teams ビデオ会議・チャット
      "skim"                  # macOS 向け PDF ビューア
      "tableplus"             # データベース GUI クライアント
      "virtualbox"            # x86 仮想化ソフトウェア
      "vnc-viewer"            # RealVNC リモートデスクトップクライアント
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.activationScripts.postActivation.text = ''
    echo "setting default shell to zsh..." >&2
    SHELL_PATH="${shellPath}"
    if [ "$(dscl . -read /Users/naoki UserShell | awk '{print $2}')" != "$SHELL_PATH" ]; then
      chsh -s "$SHELL_PATH" naoki
    fi
  '';
  environment.shells = [ shellPath ];
}
