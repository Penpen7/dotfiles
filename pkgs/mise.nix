{ pkgs }:
let
  version = "2026.11.9";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "e4509f159e0492e89065edcf52f2918e2751e3574620586058468ba0563aed59";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "21288d7a2d82066f1a2ce83c48b7b4b57753edd739b6309e578aafce0edc8a03";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "cf2900bfb4279f8d8f8a19d5c27bf1bde826b3e742182f3f67511c588498c786";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "23ba592fcbc61f057e2b82c1eafd085832712ba0c759b714ca16cd06babca378";
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
