{ ... }:
{
  my.zsh.keybindings."^r" = "fzf-select-history";

  # 履歴を fzf で選んでコマンドラインに入れる
  programs.zsh.siteFunctions = {
    fzf-select-history = ''
      local selected_command=$(history -n -r 1 | fzf --no-sort --reverse)
      if [ -n "$selected_command" ]; then
        BUFFER="''${selected_command}"
      fi
    '';
  };
}
