{ pkgs }:
let
  version = "2026.6.13";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "36478f14679e37ff38dfd3f238db6355dd5a90e1b3798b8a631d4574f46a280f";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "846f8a104086565dcad1f6416e7aacf1b8a31031b5130c9280ec81ca21774f85";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "a555743149405e87ad7da355e1c204a075671fb3cdbb196c9b4ef088f244b8ec";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "c6a9d10d0a12d224848f14733856b52e67d6664cc442cd519c75077de1e6f090";
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
