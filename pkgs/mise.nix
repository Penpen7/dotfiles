{ pkgs }:
let
  version = "2026.10.3";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "28ecc8640b0a28dab52817766f37fecfd898f1dff82e03f36fcb072e971f9246";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "791b92b446729c53e6501acd2b84ea207f541659ca9d0480c9c70c291919a321";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "e79866e32624b346f6854d93ca8a24294516cd7c0b48ce0e80af508fb7c3d8b8";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "04147c68e946902f5226dfdcd54d19907aed3cf54d95b2f27d2b9c778bb26f9e";
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
