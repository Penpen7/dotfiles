{ pkgs }:
let
  version = "2026.10.14";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "eb68c824e16af90f61e70e0d785179f335b1b95466606a5e0d8b9da504bb7bb2";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "09b1d408a41cbe9ffa4bc5a0774b681c2a833919bff6138e85cd8f5e86617b07";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "ff76e1d99fc27bcb2b3b38d1afd0798a785088aad93cc4206f2227195d2063cd";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "5bc573bc91c2571ee371f5d570cf6f8d51af3ef343b124a6609b9fec7f0d47f2";
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
