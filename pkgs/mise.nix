{ pkgs }:
let
  version = "2026.11.11";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "3a0b7a727d86bd15a64c6df9ef6531111a4741b07e6f1e2bb6f6bb5b09e2663f";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "7784da9fd85c77a0f0df6e6e39a6908089afc2a3f2c7ade78d362147fc4ef222";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "638faf3b6eb49228557876ebf3826b08011f8359599df377406b3d648a5a1d9b";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "8366f07309794f93cfdd7343e3de3d5294c185165a0ec418426508cf0733e3d7";
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
