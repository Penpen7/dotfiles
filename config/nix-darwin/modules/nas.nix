{ ... }:
{
  homebrew.casks = [
    "synology-drive"
    "tailscale-app"
  ];

  homebrew.masApps = {
    "Synology Image Assistant Extension" = 6503120862;
  };

  launchd.user.agents = {
    synology-drive = {
      serviceConfig = {
        ProgramArguments = [
          "/usr/bin/open"
          "-a"
          "SynologyDrive"
        ];
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
    tailscale = {
      serviceConfig = {
        ProgramArguments = [
          "/usr/bin/open"
          "-a"
          "Tailscale"
        ];
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
  };
}
