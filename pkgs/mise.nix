{ pkgs }:
let
  version = "2026.11.14";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "76ff289e5ef2ffdeec54ad75275795d3e05699cb74b9f2f656652d3d1ddd7d11";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "4ad598c502813f63cb9a82518f60e66f25d2c715e5bd5b949ca66323e94bd154";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "6afd537b39e2b1fe6594d4448318293d7e8c85469cbb51a6a01b28a6f26fbaf5";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "42a3ff51c24b4315d679a07bbc598e299dda12fea0dfc0d6f90a543495834831";
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
