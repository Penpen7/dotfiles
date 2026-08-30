{ pkgs }:
let
  version = "2026.8.14";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "e3ba526b629c41fa7b0918f78e746ca71a7a4b0c78dbfaca9fb25676a318762e";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "6085d0b7c7bf8e176397c48e3f1e2025bd41d69dd50f05c08cb7ae89fb7f77b1";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "940639580227bd838e3b3ea5b2084ea397399b0db162c2e4dd90b5730850e48e";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "64d5f34aeb7a4e0e327dc1c9be66cd8162e14899a47b11901154a100285a3d61";
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
