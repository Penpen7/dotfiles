{ pkgs, ... }:
{
  programs.zsh = {
    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };

    fastSyntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    completionInit = ''
      _compinit() {
        local re_initialize=0
        for match in ''${ZDOTDIR:-$HOME}/.zcompdump*(.Nmh+24); do
          re_initialize=1
          break
        done

        autoload -Uz compinit
        if [ "$re_initialize" -eq "1" ]; then
          compinit
          compdump
        else
          compinit -C
        fi
      }
      _compinit
    '';

    initContent = ''
      # 補完で小文字でも大文字にマッチさせる
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*:default' menu select=1
    '';
  };
}
