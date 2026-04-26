{ self, ... }:
{
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

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
}
