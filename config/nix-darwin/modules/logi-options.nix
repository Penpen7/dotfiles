{ ... }:
{
  homebrew.casks = [ "logi-options+" ];

  launchd.user.agents.logi-options = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/open"
        "-a"
        "Logi Options+"
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
