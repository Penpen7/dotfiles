{ pkgs }:
let
  version = "2026.9.9";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "0f13937fb7c548c4f39e3faca914f8c591c5b43a150b80db8a178afc60d4f581";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "e22ecf26ebdfbbf0d3ba2deaa3866699c555e50ad6d900894da0d7f206a4c95a";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "5f72efaa1265c9c3562ecf8d22e6623b5278700bd7ef1014a785d0ce1d1a90b2";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "e4767e4854af5daeff2191b2bbdc94f834742a23efad591dbd33187861d41604";
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
