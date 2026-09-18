{ pkgs }:
let
  version = "2026.9.11";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "34e8296f932c1d6f3b84d924bbb9f2841336d7bee1c373005d479e13664cb6c0";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "46a67b050d53f1ee795353f8ff5ecfd79328a1f6415f4b3ede79ecda7223f969";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "d781ce1b4daad6ead469b0a57fef4bfb49c4e02025dc88111ff1bfaa8c90aad9";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "02a19e4a5eda23cda916503ad09dbc608a249fe7a7d5686c5a74ff3a7ce3b7e0";
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
