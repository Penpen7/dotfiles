{ pkgs }:
let
  version = "2026.11.8";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "7a7f9342559cc4ca670054337ecf497e69d832a05f66e531628381dc92b88f48";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "355729a12f3d3b23059ad372855a82f5c8720d1d3fb63dbe5068bc9b4952201c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "b36da3c4892380325d44dee3678ba618de191254d8a4aed8011ee66b28a6cbd7";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "d2d5a46f507bba772686e2c8f2316b3a4439dac49a37a30db5c0e7bb077c5431";
      };
    }
    .${pkgs.stdenv.hostPlatform.system}
      or (throw "mise: unsupported system ${pkgs.stdenv.hostPlatform.system}");
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "mise";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-${plat.asset}.tar.gz";
    inherit (plat) sha256;
  };

  # Linux ではダウンロードしたバイナリの interpreter を修正する。
  nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.autoPatchelfHook ];

  # ルートに LICENSE / README.md を置くと buildEnv で他パッケージと衝突するため、
  # bin と share のみ展開し、LICENSE は share/doc 配下へ移す。
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./bin ./share $out/
    install -Dm644 ./LICENSE $out/share/doc/mise/LICENSE
    runHook postInstall
  '';

  meta = {
    description = "dev tools, env vars, task runner (prebuilt binary)";
    homepage = "https://github.com/jdx/mise";
    mainProgram = "mise";
  };
}
