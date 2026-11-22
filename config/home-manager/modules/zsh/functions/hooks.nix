{ ... }:
{
  programs.zsh.siteFunctions = {
    # cd したらディレクトリの中身を表示する
    chpwd = ''
      [[ -o interactive && -t 1 ]] || return 0
      pwd
      eza -F --icons=auto
    '';

    precmd = ''
      if [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
        tmux refresh-client -S
      fi
    '';
  };
}
