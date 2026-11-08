{ pkgs }:
let
  version = "2026.11.4";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "d37c01389b0918a19bbf763ee8ed339e533eebdb281be4911e9ad71d00b51477";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "b8a74f677aba6a8e418c82870c2321a563391e828b0a2474f61497e2801177de";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "e168248871cd4f958bb1597dc74d03ec65634bb54bf49c80dbb7999a7ba88471";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "e9652ecdc9ac990662ba8346b2b3da95ad9c890ed73768ea4675ef721dcef37e";
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
