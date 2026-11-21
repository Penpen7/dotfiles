{ ... }:
{
  homebrew.casks = [ "logi-options+" ];

  launchd.user.agents.logi-options = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/open"
        "-b"
        "com.logi.optionsplus"
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
