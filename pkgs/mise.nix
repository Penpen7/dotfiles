{ pkgs }:
let
  version = "2026.7.6";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "baeb42c21aec5dea45e0881b1619b8f65989187fa50481b1c70c4aa0af0429bb";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "e57eaa613672bc691bafc271f70de91350ac165c33955d35e2965067772e194c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "1e5d2181bad9b897437e8227200fe661339bad7d66a3cd1828b22c48156ac73a";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "fbd2f36a5d726822e997b83b9ca29f66411de2acb2935dcabacd4df51a0dade3";
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
