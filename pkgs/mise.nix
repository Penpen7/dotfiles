{ pkgs }:
let
  version = "2026.10.1";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "19b0ace2ffe420555d277c223f6eef252df3909f018c4faf1adf4a179b67c35a";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "70f0186533583e3e6bfc44b30b4497da10d5a5cfe487f23a642c21fb1e8d043c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "15b7e978812d1657e615f42f366c4101f9d8733b96a85b12779a9f3f3e2d8596";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "9b92aa39b8fde54b28c8f974a68f2501925a1523d6c05a52719145df3acdd75a";
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
