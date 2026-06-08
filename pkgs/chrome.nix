{ pkgs }:
let
  version = "149.0.7827.54";
  url = "https://dl.google.com/release2/chrome/dk75rnebngodpmukle2jjrfx6u_149.0.7827.54/GoogleChrome-149.0.7827.54.dmg";
  hash = "sha256-O48opD0Ea336/mbs5RFjBITjf8MWOL2BAuf6gX+pnmo=";
in
pkgs.google-chrome.overrideAttrs (_: {
  inherit version;
  src = pkgs.fetchurl { inherit url hash; };
})
