{ pkgs }:
pkgs.tmuxPlugins.resurrect.overrideAttrs (_: {
  version = "unstable-2023-03-06";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo  = "tmux-resurrect";
    rev   = "cff343cf9e81983d3da0c8562b01616f12e8d548";
    hash  = "sha256-FcSjYyWjXM1B+WmiK2bqUNJYtH7sJBUsY2IjSur5TjY=";
  };
  # git submodule (lib/tmux-test) 未取得によるリンク切れを除去
  postInstall = ''
    rm -rf $out/share/tmux-plugins/resurrect/tests \
           $out/share/tmux-plugins/resurrect/run_tests
  '';
})
