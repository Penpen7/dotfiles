{ pkgs }:
let
  # pnpm_11 同梱の node 24 は macOS で worker スレッド終了時に EXC_GUARD
  # (guarded fd の誤 close) で SIGKILL されるため node 22 で動かす
  pnpm = pkgs.pnpm_11.override { nodejs = pkgs.nodejs_22; };
  version = "5.0.8";
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  inherit version;

  # difit のリポジトリは pnpm-lock.yaml しか持たないため、本体は npm registry の
  # ビルド済み dist を使い、pnpm はランタイム依存 (node_modules) の解決だけに使う。
  src = pkgs.fetchFromGitHub {
    owner = "yoshiko-pg";
    repo = "difit";
    tag = "v${version}";
    hash = "sha256-AT2dUT14+yfMLxcJdJC/CI28RfyElsoa97vxUIMjUo0=";
  };

  distSrc = pkgs.fetchurl {
    url = "https://registry.npmjs.org/difit/-/difit-${version}.tgz";
    hash = "sha256-RGXJlgKComDU4xcxZWkYD84kMM5fR1oM1XsHhpyCvA0=";
  };

  __structuredAttrs = true;
  pnpmInstallFlags = [ "--prod" ];

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmInstallFlags
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-rSuNi81MSTH5YNz8yh5lZ5niG7+p6I5veaySP0/T2eY=";
  };

  nativeBuildInputs = [
    pkgs.nodejs
    pkgs.pnpmConfigHook
    pnpm
    pkgs.makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/difit
    tar xzf "$distSrc" --strip-components=1 -C $out/lib/difit
    cp -r node_modules $out/lib/difit/

    # workspace パッケージ (packages/vscode) はコピーしないため、
    # それを指す symlink が残ると noBrokenSymlinks で失敗する
    find $out/lib/difit/node_modules -type l ! -exec test -e {} \; -delete

    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/difit \
      --add-flags "$out/lib/difit/dist/cli/index.js"
    runHook postInstall
  '';

  meta = {
    description = "Local web server that displays Git commit diffs in a GitHub-like Files changed view";
    homepage = "https://github.com/yoshiko-pg/difit";
    mainProgram = "difit";
  };
})
