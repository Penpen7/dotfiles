{ pkgs }:
let
  version = "2026.11.12";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "f7bd19aa4e6b7a58d7296f98e2c6af68b2e2643dfd608b0bc46c2b5fdbc8749b";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "19c0e3dff9eddaab7a3519e9556be35580ade53b2bffb550f307343cb6b678ef";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "9a125763f8445ea28d2da0e943fe5ad7d81b397d78f173cc07c1cc18ee2bee47";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "4b029e19afc575875a4962dfe5d5e31cc93ab0317242768d0234adec219d3e14";
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
