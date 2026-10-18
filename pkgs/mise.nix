{ pkgs }:
let
  version = "2026.10.13";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "b91f1b30bd9e7e6899899f0ff5ac5625a90c86daa652524f7b8922db3287ff60";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "53dd8c3f08a995e88a300e561183bdd294f2aedd7d986dbcaa6c9a649dab6528";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "ec1630fd441434a1b8c8c0074a53e3e8cc955ad313e9f354c44775eb19103a57";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "b775d3feee8f0cdb1934c60a1ec26526d6eb7cdeb258b48c64cfadcec07a8fec";
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
