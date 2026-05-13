{ ... }:
{
  homebrew.casks = [ "docker-desktop" ];

  launchd.user.agents.docker-desktop = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Docker" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
