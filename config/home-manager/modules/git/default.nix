{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    git-secrets
    delta
    gh
    ghq
    hub
    lazygit # git の TUI クライアント
  ];

  home.file = {
    ".gitconfig".source = ./gitconfig;
  };

  programs.zsh = {
    shellAliases = {
      g = "git";
      gp = "git-foresta --all --style=10 | less -RSX";
      gitc = "git branch | fzf --reverse --ansi | xargs git checkout";
    };

    # ghq list を fzf で選択して cd する
    siteFunctions.ghqcd = ''
      local dir
      dir=$(ghq list | fzf-tmux --query="$LBUFFER" --select-1 --exit-0) && cd "$(ghq root)/$dir"
    '';
  };
}
