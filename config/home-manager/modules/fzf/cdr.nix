{ ... }:
{
  my.zsh.keybindings."^o" = "fzf-cdr";

  programs.zsh = {
    siteFunctions = {
      # cdr で記録したディレクトリを fzf で選んで cd する。
      fzf-cdr = ''
        local selected_dir=$(cdr -l | awk '{ print $2 }' | \
          fzf --reverse --ansi --preview 'f() { zsh -c "eza -1 --icons=always --color=always $1" }; f {}')
        if [ -n "$selected_dir" ]; then
          BUFFER="cd ''${selected_dir}"
          zle accept-line
        fi
      '';
    };

    initContent = ''
      autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
      add-zsh-hook chpwd chpwd_recent_dirs
      zstyle ':completion:*' recent-dirs-insert both
      zstyle ':chpwd:*' recent-dirs-default true
      zstyle ':chpwd:*' recent-dirs-max 1000
      zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
    '';
  };
}
