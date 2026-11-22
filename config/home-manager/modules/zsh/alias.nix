{ ... }:
{
  programs.zsh.shellAliases = {
    vim = "nvim";
    vi = "nvim";
    v = "nvim";
    gp = "git-foresta --all --style=10 | less -RSX";
    gitc = "git branch | fzf --reverse --ansi | xargs git checkout";
    aca = "acc submit a.cpp";
    va = "nvim a.cpp";
    ojt = "oj t";
    # --icons の後ろに値を書かないと、続くパスを値として読んでしまう。
    # パイプに渡すときはアイコンを出さないよう auto にする
    ls = "eza --icons=auto";
    vf = ''vim $(fzf --preview "head -100 {}")'';
    t = "tig";
    docker-clean = "docker rm $(docker ps -q -a) && docker system prune --volumes";
    ll = "ls -l";
    g = "git";
    w = "cd `workq create`";
  };
}
