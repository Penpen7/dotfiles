{ pkgs }:
let
  version = "2026.7.0";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "23efe18046d12b95895d17b2bf0101a0efb9bf174767c57b6e2c8d019b964252";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "c33f2974806db45d5a2b0ab480d0750c54328c6fe87be5cf915106d46e55b9f0";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "fcbba22dfd6bfaf94912fdba3e1f034c89841cda7a895fd2b7402cef3d7ae214";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "a3ff8f55b61504e7d7556d7b0cac4413e0c85ef7279545d2c2c3f49bd2cf8472";
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
