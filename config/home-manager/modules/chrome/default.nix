{ ... }:
{
  # Chrome の閲覧履歴を fzf で選んで開く
  programs.zsh.siteFunctions.ch = ''
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

  my.zsh.keybindings."^g" = "ch";

  programs.google-chrome = {
    enable = true;
    extensions = [
      { id = "mcbpblocgmgfnpjjppndjkmgjaogfceg"; }
      { id = "gppongmhjkpfnbhagpmjfkannfbllamg"; }
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
      { id = "iielbgdjdenipcchemkiknljbghjfdlk"; }
      { id = "ghbmnnjooekpmoecnnnilnnbdlolhkhi"; }
    ];
  };
}
