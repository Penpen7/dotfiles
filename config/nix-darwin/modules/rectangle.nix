{ ... }:
{
  homebrew.casks = [ "rectangle" ];

  launchd.user.agents.rectangle = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/open"
        "-a"
        "Rectangle"
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
