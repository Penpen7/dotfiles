{ pkgs }:
let
  version = "2026.10.18";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "1b1cd6ad4a6176db5ddaf03bf71e131b26324af09cfcf14d7d7038bee60be85d";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "81931f325cfc97481faa558297dbd1595aa9c4e745fd09c02479593449e082c0";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "c5a49a47f8184f5649f3d8685b408bd72325a823f41cf618c60f3ffc303090a1";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "0d41b60745a6273a80089c86f80d8729042d2f57f87fda70aecc7d1c3ffbd3be";
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
