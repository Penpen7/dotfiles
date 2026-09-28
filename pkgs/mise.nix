{ pkgs }:
let
  version = "2026.9.15";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "18407dc1ee5c2efdb808ac5272c989692c4ecc951933e84eb44cf5ac554ac2f9";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "8dadf477c1cfd6a235e926f6de867cf0dfacedeb0b7d30ad9c4583b5311989a1";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "254f60912e73c9420f03be8bab90ac80c0056db6826814b1a91cb4a0f872c1db";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "2148d2485d1e6e48eb918729d86af4ecd438f9b5b63be360fb26005c85f0d853";
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
