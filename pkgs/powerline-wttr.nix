{ pkgs }:
pkgs.python3Packages.buildPythonPackage rec {
  pname = "powerline-wttr";
  version = "0.1";
  format = "wheel";
  src = pkgs.fetchurl {
    url = "https://files.pythonhosted.org/packages/e9/23/2f3a2500d2a3df5bd6c9750a175379f4f65b0edd63173c89e69dfa35781d/powerline_wttr-0.1-py3-none-any.whl";
    hash = "sha256-qSt/RTgzM+ISamiyXsuOrCXtEB9emg39itCMIpTKoTI=";
  };
  propagatedBuildInputs = with pkgs.python3Packages; [
    powerline
    requests
  ];
  doCheck = false;
}
