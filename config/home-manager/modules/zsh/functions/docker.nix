{ ... }:
let
  # fzf で起動中のコンテナを選び、そのコンテナでコマンドを実行する
  dockerExec = shell: ''
    local container
    container="$(docker container ls -a -f status=running | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
    if [ -n "''${container}" ]; then
      echo "attaching container ..."
      docker exec -it ''${container} ${shell}
    fi
  '';
in
{
  programs.zsh.siteFunctions = {
    docker-attach = ''
      local container
      container="$(docker container ls -a -f status=running | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
      if [ -n "''${container}" ]; then
        echo "attaching container ..."
        docker container attach ''${container}
      fi
    '';

    docker-sh = dockerExec "/bin/sh";
    docker-bash = dockerExec "/bin/bash";

    docker-run = ''
      local container
      container="$(docker image ls | sed -e '1d' | fzf --height 40% --reverse | awk -v 'OFS=:' '{print $1,$2}')"
      if [ -n "''${container}" ]; then
        echo "runing container from ''${container} ..."
        docker container run -it ''${container} bash
      fi
    '';
  };
}
