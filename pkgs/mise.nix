{ pkgs }:
let
  version = "2026.9.12";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "0f1c7f3e74d8c9ae82976e6990058f2bc68821acc6b4c37a68c206c836692419";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "22be38ec60632913143bf6a96b0aacfd895fdfe4ce4e8958e942f7bdb5a9185b";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "e4a0921da0a76ce4666832d5b57b6f0eb9f22d149ba92845ebae4c38638c6775";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "b4058dece685259910d3aba5782445996eea79dbdb3cf952a6eb81aadf0373ff";
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
