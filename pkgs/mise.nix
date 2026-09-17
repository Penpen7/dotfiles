{ pkgs }:
let
  version = "2026.9.10";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "7d0c48e10a46a9cd6cf466303827cec34af6e5ed526c34d9348944eca9bcec99";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "6704c8986e60d1b03e3b2e95e88bc24b20e94bb762f26d6ec88755115638fc53";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "efbfab6beaac07f933b63a95cb8746bbb7b2d48b70f636c19eb03a38f5786361";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "cf6c0d4713932cf47da67f4f753348bc1ccf9a22d4d1e3c76d3c23a6187a853c";
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
