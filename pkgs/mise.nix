{ pkgs }:
let
  version = "2026.10.4";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "744ae45f9b7c2a443adfa61df48397930e88b13c541834b7bd22ca31d4dfcfcd";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "3bf65cfdb543f69685afde3ae9ccd0b819b8f5ea5d12c67c73487bf2a1b16bf4";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "8760841cdbf964ecf9902a50c94716c77185a99af7f8eb55c9c51ec73ecd8880";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "2fc793020b442d08163603400236b2c693f8cede810c7e432fc77220e6c9e8a1";
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
