{ pkgs }:
let
  version = "2026.10.24";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "aa2fc59242db108f97ea9fb2d2e2cb42ff1467fcafe3c91e48d51c841ba67a65";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "83a36355bf6ee7c1660300e12dd94464de5c672dab1b8cc33ec4d19356e7ddac";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "8c8f5d7f748bf3aef431dc50f0ad776270f36025c788aa21c74e2fabdbbd6d3e";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "9a6c9c55f5c6372d0af70a9979fe6d742aea3793267a929e1738022143c466cc";
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
