{ pkgs }:
let
  version = "1.91.168";
  archives = {
    aarch64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-v${version}-darwin-arm64.zip";
      hash = "sha256-kE4/GSEL4dDTy4aqqg6JqyzNIlCcIDGdPxAgCAPEN3Q=";
    };
    x86_64-darwin = {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-v${version}-darwin-x64.zip";
      hash = "sha256-ocRwDMegXcGMFRQSVVTNjT/OlHlNiTHYCjHWJSaz1Z8=";
    };
  };
  archive = archives.${pkgs.stdenv.hostPlatform.system};
in
pkgs.brave.overrideAttrs (_: {
  inherit version;
  src = pkgs.fetchurl archive;
})
