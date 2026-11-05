{ pkgs }:
let
  version = "2026.11.1";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "e1eaf20469e586f65849256a0be6a58dd7a3e93ae8db68bc74dd7af5ca0fe7f6";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "c22089a8cb02e8e3eca09b45aad2674bf537313692bf105e9b8e5ab24ce8552f";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "6b54d9223f8bce04f9168ef482d9ee27f219c1ea11f4903569660049e5dec5aa";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "9c3f740597f5e5815ecb50ec6fafa080e94472d0780220bcb214eb98bd902dca";
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
