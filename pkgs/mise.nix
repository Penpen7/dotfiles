{ pkgs }:
let
  version = "2026.6.14";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "6d8d389bd729f5c44094a5d8e9df5c410acf4304e2540eb79a4854bdd22d0a91";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "da8f8872ba962d6893f0bab68b5a894caa296f1d17c2850ca407699441b44b26";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "6d71ba01f20bb7cc7bfffac5214e9e788a08fa517c075eb955a5b31dca667ca7";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "c5bb4546ba2d5154e9c8236e2774bd8289b64c409330ed41cb6d6b8ebc31fb56";
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
