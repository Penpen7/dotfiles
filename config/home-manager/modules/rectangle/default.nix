{ pkgs, ... }:
{
  home.packages = [ pkgs.rectangle ];

  launchd.agents.rectangle = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.rectangle}/Applications/Rectangle.app/Contents/MacOS/Rectangle"
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
