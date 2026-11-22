{ ... }:
{
  my.zsh.keybindings = {
    "^r" = "fzf-select-history";
    "^o" = "peco-cdr";
  };

  programs.zsh = {
    siteFunctions = {
      fzf-select-history = ''
        local selected_command=$(history -n -r 1 | fzf --no-sort --reverse)
        if [ -n "$selected_command" ]; then
          BUFFER="''${selected_command}"
        fi
      '';

      # cdr で記録したディレクトリを fzf で選んで cd する。
      # プレビューは端末に直接出力されないので、アイコンと色は always で出す
      peco-cdr = ''
        local selected_dir=$(cdr -l | awk '{ print $2 }' | \
          fzf --reverse --ansi --preview 'f() { zsh -c "eza -1 --icons=always --color=always $1" }; f {}')
        if [ -n "$selected_dir" ]; then
          BUFFER="cd ''${selected_dir}"
          zle accept-line
        fi
      '';

    };

    # cdr の設定。zstyle に当たる設定項目は Home Manager にないので initContent に書く
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
