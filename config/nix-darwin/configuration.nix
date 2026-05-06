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
        KeyRepeat = 1;         # キーリピート速度（小さいほど速い、デフォルト6）
        InitialKeyRepeat = 15; # キーリピート開始までの遅延（小さいほど速い、デフォルト25）
        "com.apple.swipescrolldirection" = false; # ナチュラルスクロールを無効化
        "com.apple.trackpad.forceClick" = false;  # Force Clickを無効化
        AppleEnableSwipeNavigateWithScrolls = false; # スワイプでの前後ページ移動を無効化
      };

      finder = {
        ShowPathbar = true;    # パスバーを表示
        ShowStatusBar = true;  # ステータスバーを表示
      };

      trackpad = {
        Clicking = true;              # タップでクリック
        TrackpadThreeFingerDrag = true; # 三本指でドラッグ
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowTabView = true; # タブバーを表示
        };
        "com.microsoft.VSCode" = {
          ApplePressAndHoldEnabled = false; # VSCodeでキーリピートを有効化
        };
        "com.microsoft.VSCodeInsiders" = {
          ApplePressAndHoldEnabled = false;
        };
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
    masApps = {
      "AmorphousDiskMark" = 1168254295;
      "Dropover" = 1355679052;
      "Elmedia Video Player" = 1044549675;
      "GarageBand" = 682658836;
      "GeoGebra Classic 6" = 1182481622;
      "iMovie" = 408981434;
      "iWifi" = 1476136371;
      "Keynote" = 409183694;
      "Kindle" = 405399194;
      "LINE" = 539883307;
      "Logic Pro" = 634148309;
      "Magnet" = 441258766;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Parallels Desktop" = 1085114709;
      "PicGIF Lite" = 844918735;
      "RunCat" = 1429033973;
      "Skitch" = 425955336;
      "Synology Image Assistant Extension" = 6503120862;
      "Ultra Wifi" = 1664371307;
      "WiFi Explorer" = 494803304;
      "Xcode" = 497799835;
    };
    casks = [
      "adobe-acrobat-reader"  # Adobe Acrobat PDF リーダー
      "claude"                # Claude AI デスクトップアプリ
      "docker-desktop"        # Docker Desktop for Mac
      "izotope-product-portal" # iZotope Product Portal
      "kap"                   # 画面録画ツール
      "logi-options+"         # Logicool デバイス管理アプリ
      "minecraft"             # Minecraft Launcher
      "microsoft-auto-update" # Microsoft アプリの自動更新ツール
      "microsoft-teams"       # Microsoft Teams ビデオ会議・チャット
      "synology-drive"        # Synology Drive Client
      "tableplus"             # データベース GUI クライアント
      "tailscale-app"         # Tailscale VPN クライアント
      "virtualbox"            # x86 仮想化ソフトウェア
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
