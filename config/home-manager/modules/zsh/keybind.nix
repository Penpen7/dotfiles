{ config, lib, ... }:
let
  cfg = config.my.zsh;
  widgets = lib.unique (
    lib.filter (w: config.programs.zsh.siteFunctions ? ${w}) (lib.attrValues cfg.keybindings)
  );
in
{
  options.my.zsh.keybindings = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      "^r" = "fzf-select-history";
    };
    description = "zsh のキー割り当て (キー → ウィジェット名)";
  };

  config = {
    programs.zsh = {
      defaultKeymap = "viins";

      siteFunctions.__source = "source ~/.zshrc";

      initContent = ''
        ${lib.concatMapStringsSep "\n" (w: "zle -N ${w}") widgets}
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (key: widget: "bindkey ${lib.escapeShellArg key} ${widget}") cfg.keybindings
        )}
      '';
    };

    my.zsh.keybindings = {
      "jj" = "vi-cmd-mode";
      "^s" = "__source";
    };
  };
}
