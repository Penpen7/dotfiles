{ pkgs }:
pkgs.python3Packages.buildPythonPackage rec {
  pname = "powerline-mem-segment";
  version = "2.4.1";
  pyproject = true;
  src = pkgs.python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-KcZr7pxHkk6mL97c2hxeNoZzG2vKFMzamT8R8g7/BxQ=";
  };
  build-system = [ pkgs.python3Packages.setuptools ];
  propagatedBuildInputs = with pkgs.python3Packages; [
    powerline
    psutil
  ];
  doCheck = false;
}
