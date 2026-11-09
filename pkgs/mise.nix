{ pkgs }:
let
  version = "2026.11.5";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "f69c8a4f7c265d5f3ffdd06d44104aa15a7ffd9b6545a87b7768f893b70f0fd8";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "67f980425c594e59675027d8b522901dee80a94bafadcdc4dfdcce14f0cc3b40";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "146b114c2714f6ed76a629778f162d578e14821e47b87389dbdd64068bd5cf06";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "d7dee029352bf4b8986e7c4696b8ce54746c3eb648ffca3cc69bdeecc0ff06e9";
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
