{
  self,
  pkgs,
  username,
  ...
}:
let
  shellPath = "/bin/zsh";
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    hackgen-font
    hackgen-nf-font
    nerd-fonts.jetbrains-mono
  ];

  system = {
    stateVersion = "5.0";
    primaryUser = username;
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      dock = {
        orientation = "left";
        tilesize = 128;
        magnification = true;
        largesize = 79;
        autohide = false;
      };

      NSGlobalDomain = {
        KeyRepeat = 1;
        InitialKeyRepeat = 15;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.forceClick" = false;
        AppleEnableSwipeNavigateWithScrolls = false;
      };

      finder = {
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowTabView = true;
        };
        "com.microsoft.VSCode" = {
          ApplePressAndHoldEnabled = false;
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
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    masApps = {
      "AmorphousDiskMark" = 1168254295;
      "Dropover" = 1355679052;
      "Elmedia Video Player" = 1044549675;
      "GeoGebra Classic 6" = 1182481622;
      "Keynote" = 409183694;
      "Magnet" = 441258766;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Parallels Desktop" = 1085114709;
      "PicGIF Lite" = 844918735;
      "RunCat" = 1429033973;
      "Skitch" = 425955336;
      "Xcode" = 497799835;
    };
    casks = [
      "adobe-acrobat-reader"
      "alfred"
      "cleanshot"
      "claude"
      "docker-desktop"
      "handbrake-app"
      "hazeover"
      "obs"
      "kap"
      "logi-options+"
      "microsoft-auto-update"
      "microsoft-teams"
      "rustrover"
      "tableplus"
      "virtualbox"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.${username}.home = "/Users/${username}";
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.activationScripts.postActivation.text = ''
    echo "setting default shell to zsh..." >&2
    SHELL_PATH="${shellPath}"
    if [ "$(dscl . -read /Users/${username} UserShell | awk '{print $2}')" != "$SHELL_PATH" ]; then
      chsh -s "$SHELL_PATH" ${username}
    fi
  '';
  environment.shells = [ shellPath ];
}
