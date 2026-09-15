{ pkgs }:
let
  version = "2026.9.8";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "a06f7e0d425848a09278af3da48b463491db2aa70e4a236e06476b25c5eb95bc";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "edaa8219a64486be6e8d66e6815a6908602f47588741ab42bc7bffe27d204987";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "bf6b498d1ee5cdcd7b50923f06c2bbf19f85746c662eb1e6b1677888f256956c";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "9809cd06cd86bcc88b262038605019645a069019ee1c1a49cbc7ea7386cc08dd";
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
