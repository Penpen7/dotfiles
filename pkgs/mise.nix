{ pkgs }:
let
  version = "2026.10.23";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "b9146f565a02c18dc117e63a9e59ec1cb5189d1602e2cc68b27c0322c2a5908d";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "38f56451213155378580a205ffb39ffd516e1ae60a748631a000ada7cc0a9e49";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "4ae04207468000b50eb457610de80a0779b119ef32684e7489770934d36f9ad9";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "4be3403954d8e8cdeba93bddd10212ae8ecb69ce549833041805a027b803d996";
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
