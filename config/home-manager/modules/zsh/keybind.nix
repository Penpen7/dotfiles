{ lib, ... }:
let
  # zle ウィジェットとして登録する関数
  widgets = [
    "ch"
    "docker-bash"
    "docker-run"
    "docker-sh"
    "fzf-select-history"
    "peco-cdr"
    "__source"
    "__tig"
    "__vim"
  ];

  keybindings = {
    "jj" = "vi-cmd-mode";
    "^g" = "ch";
    "^g^t" = "__tig";
    "^o" = "peco-cdr";
    "^r" = "fzf-select-history";
    "^s" = "__source";
    "^v" = "__vim";
    "^x^b" = "docker-bash";
    "^x^r" = "docker-run";
    "^x^s" = "docker-sh";
  };
in
{
  programs.zsh = {
    defaultKeymap = "viins";

    siteFunctions = {
      __source = "source ~/.zshrc";
      __tig = "tig";
      __vim = "nvim";
    };

    # キー割り当てに当たる設定項目は Home Manager にないので initContent に書く
    initContent = ''
      ${lib.concatMapStringsSep "\n" (w: "zle -N ${w}") widgets}
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: widget: "bindkey ${lib.escapeShellArg key} ${widget}") keybindings
      )}
    '';
  };
}
