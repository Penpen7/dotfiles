{ pkgs }:
let
  version = "2026.9.17";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "63deaba3321800014feb6a92f1fed38680edf8deccbe972beebcdae7b67f3172";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "b287fd5edcbe5a488a7b63d88b48ec54b9bfeb2df9862a51ee889009444c6f5f";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "46717187f93d4ebfff8b87a30da3f5939af995057c0c1a855e968f0ee4d19c88";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "8d1bcbc0b2ba167ee765e7410502c3f89974d0195eb8ec74537bc93bb367420d";
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
