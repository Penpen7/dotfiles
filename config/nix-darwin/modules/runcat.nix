{ ... }:
{
  homebrew.masApps = {
    "RunCat" = 1429033973;
  };

  launchd.user.agents.runcat = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "RunCat" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
