{ ... }:
{
  # macOS の既定のファイルディスクリプタ上限 (kern.maxfiles=30720, maxfiles soft=256) が低く、
  # darwin-rebuild で大量に並列ビルドすると "too many open files" になるので引き上げる。
  launchd.daemons.maxfiles = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/usr/sbin/sysctl -w kern.maxfiles=524288 kern.maxfilesperproc=524288 && /bin/launchctl limit maxfiles 65536 524288"
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
