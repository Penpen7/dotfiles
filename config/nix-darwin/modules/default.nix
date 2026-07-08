{
  self,
  pkgs,
  config,
  homebrew-core,
  homebrew-cask,
  ...
}:
let
  username = config.system.primaryUser;
  shellPath = "${pkgs.zsh}/bin/zsh";
in
{
  nixpkgs.config.allowUnfree = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  fonts.packages = with pkgs; [
    hackgen-font
    hackgen-nf-font
    nerd-fonts.jetbrains-mono
  ];

  system = {
    stateVersion = "5.0";
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      dock = {
        orientation = "left";
        tilesize = 128;
        magnification = true;
        largesize = 79;
        autohide = false;
        show-recents = false;
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
    # Declare the nix-homebrew managed taps in the Brewfile so the `zap`
    # cleanup below does not try to untap them.
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };
    masApps = {
      "AmorphousDiskMark" = 1168254295;
      "Dropover" = 1355679052;
      "Elmedia Video Player" = 1044549675;
      "GeoGebra Classic 6" = 1182481622;
      # "Keynote" = 361285480; todo: need to update osx
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Parallels Desktop" = 1085114709;
      "PicGIF Lite" = 844918735;
      "Skitch" = 425955336;
    };
    casks = [
      "adobe-acrobat-reader"
      "alfred"
      "cleanshot"
      "claude"
      "discord"
      "handbrake-app"
      "obs"
      "kap"
      "rustrover"
      "slack"
      "virtualbox"
      # "vnc-viewer"
      "zoom"
      "iterm2"
    ];
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
    watchIdAuth = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.${username}.home = "/Users/${username}";
  nix.enable = false;
  system.activationScripts.postActivation.text = ''
    echo "setting default shell to zsh..." >&2
    SHELL_PATH="${shellPath}"
    if [ "$(dscl . -read /Users/${username} UserShell | awk '{print $2}')" != "$SHELL_PATH" ]; then
      chsh -s "$SHELL_PATH" ${username}
    fi
  '';
  environment.shells = [ pkgs.zsh ];
}
