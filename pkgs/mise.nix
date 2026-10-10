{ pkgs }:
let
  version = "2026.10.7";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "5841e5ab5009b4c4dd2b641ddbfc6777cc1b9c9c0ffd375001e294540e9e9cc8";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "809b60fb1f7f5b8794db9c2ac78e5dc40df2e2a2e91d75e7dc97da1ecdc2755e";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "67bfc43bcc28de3a461b29fcf13a94a06019e4a1d3be37e4ff2c1347a576449b";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "3d31e3a53e8041b278ca999a4772d4575583098025384126e7aa8a31e0dac11c";
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
