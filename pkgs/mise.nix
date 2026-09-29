{ pkgs }:
let
  version = "2026.9.16";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "ce340c6c4bfd4b515557062276184a4b2be4aeec4120173b017bb1179414de88";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "12eabbec662f87fbe8e39bd5e2cc5b0796cd18ebf58cf5ad41fef981c6757d51";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "a19097ac76225b3ebe78b1a93ad302f1fe3e6fa9f40edf724deb3b83244bb7ff";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "2e022482d62a3b9e6c0bc51d3e883401bfa7e4684b60f3b819b21eae4ebdb438";
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
