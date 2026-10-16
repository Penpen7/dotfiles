{ pkgs }:
let
  version = "2026.10.11";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "64592e2978459d91b9dc690352c97d59a8c2b327f586fd201468fa56afe66311";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "6eaffe02521c700b420ba6930dfbc528951f27c1c9896c827ab6aab7248c75f1";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "7534d514495449e267997410583833080ed0b99a0053f3b26a10691794a597b5";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "a7d0aad3d6782d42675fe0a2732b39bfc356f6cf2b554437f84c597814a2fd85";
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
