{ pkgs }:
let
  version = "2026.9.5";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "cb994f2e8a94fbf00300045c81ee799ffebcd8e78241ff37b0aa2da96b924aad";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "c31958952868b7b37ec6a5f46ee1a82d1382470bf15f2c663e7cb35ac0acf88c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "3a52c7c7c58d21a0791516950ebf4bc915f403277b49c93d657fc585259625ec";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "d71e94e1ed59d4d0ca4ac847fa321d6d6615a8e613e9b468c9fb39f0dddd06d5";
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
