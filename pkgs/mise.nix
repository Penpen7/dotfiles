{ pkgs }:
let
  version = "2026.9.7";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "f6810aa1609a475ce7f3fdc83eb1e090ace6231d3b1b5aaead944663c4b4b7f1";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "98d6fa19fbf6022558ffbbf259800fc7f3dd696fdc950b922d7f3f53e75ef36b";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "d8d38909537af5864822f3ad545d48f1cefae15db266b20052a32da7f834fd50";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "6cc34785ae10c38061e569b64b290fc8ac26e94d12c3f1aeb721790fa8f09196";
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
