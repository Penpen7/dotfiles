{ pkgs }:
let
  version = "2026.10.21";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "d67b6006cb1144131910ce80d6cf52134f55b9c7da55648bd717df36b3f238d6";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "722848fc0522a996bccca35ceef614b3926bb1ae97b145fe11bb08cf960b31f9";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "1c05e4d4baaf1b4a9bf929e9c39b3512deb937c8d4c1bd52927499624018834f";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "f56cc56b462eaae60aa7a33dffd24f641847b52e098b69e4a5064c4b8bbe03cb";
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
