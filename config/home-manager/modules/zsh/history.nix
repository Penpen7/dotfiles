{ ... }:
{
  programs.zsh = {
    autocd = true;

    history = {
      path = "$HOME/.zsh_history";
      size = 100000;
      save = 1000000;
      share = true;
      ignoreAllDups = true;
      ignoreSpace = false;
    };

    setOptions = [
      "AUTO_PUSHD"
      "CORRECT"
      "PUSHD_IGNORE_DUPS"
      "INC_APPEND_HISTORY"
    ];
  };
}
