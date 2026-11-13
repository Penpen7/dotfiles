{ pkgs }:
let
  version = "2026.11.7";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "92f1b9f68b6031a9f77938a0ff8dfd7a77fe9cd918c5b09d0ed434f06ebbd3f2";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "69a0eddf86f275cb81be9d49a607460f2c068d77c1c0e37b2d81513074eff36c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "b8de6c8e7aa85752a6a2368df32393552a2d8947b6f4072ecd29a1ad972e5c40";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "3198a5ed5716ca8c17ecfc54521e2769d6cacbf2d13f24f0c2f9706620ec0024";
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
