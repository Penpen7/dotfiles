{ ... }:
{
  imports = [
    ./history.nix
    ./cdr.nix
  ];

  programs.fzf = {
    enable = true;
    # 公式のキー割り当て (^R、^T、Alt-C) は使わない。履歴検索は history.nix の自作のものを使う
    enableZshIntegration = false;
  };
}
