{ pkgs }:
let
  version = "2026.9.13";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "4698c2537eef78830bd5acf98204100fb0ad9a8884861e55265e855f35aa3fa0";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "1244981f542e39d3ceaa4a548d59b793c052f419db760e139839d47d17fae483";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "0a9b8c243e717df2706e6822855ac8cfd5089745400565a815a93803cfcd4042";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "827c7997af2e0e5a418f266ead5df99ee4aae9b6fd435df8dbe79d90f335ff9a";
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
