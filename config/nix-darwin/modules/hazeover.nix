{ ... }:
{
  homebrew.casks = [ "hazeover" ];

  launchd.user.agents.hazeover = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "HazeOver" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
