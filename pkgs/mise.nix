{ pkgs }:
let
  version = "2026.10.22";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "a03278808ca2449933c28921d48c75f15f69fdde3f893b51abc7bd35a679a716";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "5358da33f912652d532899bc98d44b6177cadd3be013dbc72c7c4ca500a0f336";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "d50359b2cf4d8ad366dea96e00b07b6b1549671df7851b0285faef1365eb19db";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "b8c44caa1ff2f7c417e0d40efc9235839e84bb9f55a13f93c128d48941c145a9";
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
