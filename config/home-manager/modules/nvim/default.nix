{ pkgs, ... }:
{
  home.packages = [ pkgs.nvim ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
  };

  programs.zsh = {
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      vf = ''nvim $(fzf --preview "head -100 {}")'';
    };

    siteFunctions.__vim = "nvim";
  };

  my.zsh.keybindings."^v" = "__vim";
}
