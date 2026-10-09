{ pkgs }:
let
  version = "2026.10.5";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "c638523f3bfd39c7ecb6c24c67c6dd83d72932c5fcdb778d3e8ad4b070ee5fda";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "19fa1f89af2a79cfe6519538983f1ece7cad54542e3ef349e4d5de8fbcf07f2e";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "bde532a1eb78f43a0d3180f618c0266733aa1c8fffbacd24569bbc75a7273871";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "c5148a66c28c567da9064a52e03a981f072ff21837e094e060cb9cfbd6a35b04";
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
