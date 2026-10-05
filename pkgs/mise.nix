{ pkgs }:
let
  version = "2026.10.2";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "a3f67ff009f1436013eee37864c1c1855d9d9a9e4982a660b6495589635384e7";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "cc1497f6c370580d81d386004578f97d36b08031f6534818e0fd2756d54d0aca";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "5d3368679ce0cc37fb222511a04c61426cded69f0cda0f8248d03970dc34f303";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "79a2bf0ffc9b8a9a6391344e875b3c3679c15053fda3e8728ddf1790d63db788";
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
