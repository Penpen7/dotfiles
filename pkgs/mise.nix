{ pkgs }:
let
  version = "2026.10.12";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "6dc12b6087d4887cf807e9a9f3c2aa0ae0d90a6f465c6bd9c5d4a07847f88ab3";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "ddb347d57323cb418d01c2721838648f9b0288918ee4807df991cd87021c8b20";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "e6db9cd4cd45dfa0323080badb23db59951ce3cf077f54c691066735220085c6";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "aa5f8fbbb942296bbeea3769abf56c6f4ee37da4d203f0044b227cac4d929a87";
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
