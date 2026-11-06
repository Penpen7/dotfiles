{ pkgs }:
let
  version = "2026.11.2";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "658229370356b34be161a29ed9daf1342239b741a93e1a92d71ce040b7bb3e0c";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "ac3fe8f777556d5e57f14c9a525d2aa23ece3631cd350bd5b9ca0381c57aa564";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "4d69f304a1501441cf455f6c7f96b117a10c27a568cdda3b5d1fa8e67476b038";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "c914dc3be1ad3588c3a7fa8ddae86c65e77eaf1777aa4a900c215e467f4c94a4";
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
