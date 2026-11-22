{ config, lib, ... }:
let
  cfg = config.my.zsh;
  # siteFunctions で定義した関数は zle ウィジェットとして登録する
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
    description = ''
      zsh のキー割り当て (キー → ウィジェット名)。
      ウィジェット名が programs.zsh.siteFunctions の関数なら、zle -N で自動的に登録する。
    '';
  };

  config = {
    programs.zsh = {
      defaultKeymap = "viins";

      siteFunctions.__source = "source ~/.zshrc";

      # キー割り当てに当たる設定項目は Home Manager にないので initContent に書く
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
