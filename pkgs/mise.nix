{ pkgs }:
let
  version = "2026.11.0";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "9c3678b20515f091208b3a2a9900bbc5ab7f228a1c5893849f0f2939b1829df3";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "8d5caf1b2a2ea6064795274c6a52c9d8f57c0924485a5a97238a3a571bd43566";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "92f90c094b6eab2dcdbc46f2b977a78bba82a9311fe0c592c17e403a8d0ec621";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "cf48795ee2cb3f8822ba0ed4b45d729b791fe0c984baf6080ebb7b0c1ba23119";
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
