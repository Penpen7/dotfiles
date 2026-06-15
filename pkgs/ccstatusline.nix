{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "ccstatusline";
  version = "2.2.21";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${version}.tgz";
    hash = "sha256-lpEDPSBcOHvMrTpIewCJyXyMBPgliFxR1WXVvsRLadM=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  sourceRoot = "package";

  installPhase = ''
    mkdir -p $out/lib/ccstatusline $out/bin
    cp -r dist $out/lib/ccstatusline/

    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ccstatusline \
      --add-flags "$out/lib/ccstatusline/dist/ccstatusline.js"
  '';

  meta = {
    description = "Claude Code status line for terminal";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    mainProgram = "ccstatusline";
  };
}
