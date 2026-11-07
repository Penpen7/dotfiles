{ pkgs }:
let
  version = "2026.11.3";

  # nixpkgs の mise は Rust ソースからビルドされてしまうため、
  # GitHub Releases のビルド済みバイナリを取得してビルドを回避する。
  plat =
    {
      aarch64-darwin = {
        asset = "macos-arm64";
        sha256 = "de9a54330fee4edede51a3cf6196bbf522f01c5e3fd981e0bebea33f561a0431";
      };
      x86_64-darwin = {
        asset = "macos-x64";
        sha256 = "88389a4a624a7279ec8d2d06e5c0fbd874ce4f5de791767883b32f62f4e1d62c";
      };
      aarch64-linux = {
        asset = "linux-arm64";
        sha256 = "13547a80d1dc2d5f81bb183023732f4981486e894d060e30993cc4364b4af51d";
      };
      x86_64-linux = {
        asset = "linux-x64";
        sha256 = "837acae6defb8c9ad74823f6e38856633bacb04c65c1ac67d952749847543bd9";
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
