{ ... }:
{
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

      # Chrome の閲覧履歴を fzf で選んで開く
      ch = ''
        local cols sep google_history open
        cols=$(( COLUMNS / 3 ))
        sep='{::}'

        if [ "$(uname)" = "Darwin" ]; then
          google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
          open=open
        else
          google_history="$HOME/.config/google-chrome/Default/History"
          open=xdg-open
        fi
        \cp -f "$google_history" /tmp/googlechrome_fzf
        sqlite3 -separator $sep /tmp/googlechrome_fzf \
          "select substr(title, 1, $cols), url
            from urls order by last_visit_time desc" |
        awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
        fzf --reverse --no-hscroll --ansi --multi --preview-window down:0 | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
      '';

      # ghq list を fzf で選択して cd する
      ghqcd = ''
        local dir
        dir=$(ghq list | fzf-tmux --query="$LBUFFER" --select-1 --exit-0) && cd "$(ghq root)/$dir"
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
