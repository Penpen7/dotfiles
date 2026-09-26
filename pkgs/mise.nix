{ pkgs }:
let
  version = "2026.9.14";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "39bce868a71fac11dfd7c4170fcb6dcacfdd53dfab5656b23da56a85883568eb";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "3fd3e73e4ab239af542a88b8132023edaeeae8cefad61aed7ceedcc7ea45d54b";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "49a1185936100e061471d7035cbaf3eb13d17a6e1772daae2e1ec6cee0fb2d22";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "343b133839d6a1d6c92daca90c4dbf7981dc28de8d308e5198a4ef24df8f5338";
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
