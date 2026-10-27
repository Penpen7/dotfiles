{ pkgs }:
let
  version = "2026.10.20";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "c47629720ff02d5a1f7b3e5923d7cd523baa7ad9531e0ab86d9153ec2f9d25c7";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "0cfb0ba5a58670214bdbca2498c1c241583d9e666d997d30d422c67554f75f58";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "edc691d8b31d2951a13be8e476f894ea053c04b79eae17cd65d75d4d15404e5a";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "5a9057180c3a9a795076f84be4f5f372e6e37179e1aeb49732928d6b395ce829";
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
