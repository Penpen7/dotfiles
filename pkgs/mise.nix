{ pkgs }:
let
  version = "2026.9.6";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "47d93429ab421a47e7ca158cdc97aad5c12475c7b306e600583b5b00d6922b8f";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "9acaa836e0ab8f476aadb5d1ee90d92c08bf4163e3ad4e9e4ba8e2223cceed1f";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "9d5d4c3187ccc2c5a9659be427231208eba689c8adcc0203004c4c2ef75caf8d";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "afa8079a2c75a48d8d39bbb6ca5566c652bda8ae49ce8ca1f41a72e80184140f";
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
