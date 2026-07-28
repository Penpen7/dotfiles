{ pkgs }:
let
  version = "2026.7.15";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "4898a07e7b501e01ee9ba11df96a0141460b4eef30be8e7cb0f3d698d4222d07";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "a72eaa7ff33d1d69847fc181f774f26f74c37c0624f4492bd3bfe88e1874005b";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "0c2ca4d4ee79720a08d2c5f54c986450348b0fe25ace2bf9998dbe6c6761bf16";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "0785821a617e85197104c021835072ca3f4fcdda143538293a30593acc258969";
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
