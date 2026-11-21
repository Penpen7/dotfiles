{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  # zle ウィジェットとして登録する関数
  widgets = [
    "ch"
    "docker-bash"
    "docker-run"
    "docker-sh"
    "fzf-select-history"
    "peco-cdr"
    "__source"
    "__tig"
    "__vim"
  ];

  keybindings = {
    "jj" = "vi-cmd-mode";
    "^g" = "ch";
    "^g^t" = "__tig";
    "^o" = "peco-cdr";
    "^r" = "fzf-select-history";
    "^s" = "__source";
    "^v" = "__vim";
    "^x^b" = "docker-bash";
    "^x^r" = "docker-run";
    "^x^s" = "docker-sh";
  };

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
  programs.dircolors = {
    enable = true;
    # Home Manager の既定値は使わず、nord.dircolors だけを使う
    settings = lib.mkForce { };
    extraConfig = builtins.readFile ./nord.dircolors;
  };

  programs.zsh = {
    enable = true;

    # setopt no_global_rcs: /etc/zprofile や /etc/zshrc を読み込まない
    envExtra = ''
      setopt no_global_rcs
    '';

    autocd = true;
    defaultKeymap = "viins";

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

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      gp = "git-foresta --all --style=10 | less -RSX";
      gitc = "git branch | fzf --reverse --ansi | xargs git checkout";
      aca = "acc submit a.cpp";
      va = "nvim a.cpp";
      ojt = "oj t";
      ls = "eza --icons";
      vf = ''vim $(fzf --preview "head -100 {}")'';
      t = "tig";
      docker-clean = "docker rm $(docker ps -q -a) && docker system prune --volumes";
      ll = "ls -l";
      g = "git";
      w = "cd `workq create`";
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };

    # ウィジェットを定義し終えてから読み込まれる
    fastSyntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    # .zcompdump が 24 時間以上古いときだけ compinit で作り直し、それ以外は -C で検査を省く
    completionInit = ''
      _compinit() {
        local re_initialize=0
        for match in ''${ZDOTDIR:-$HOME}/.zcompdump*(.Nmh+24); do
          re_initialize=1
          break
        done

        autoload -Uz compinit
        if [ "$re_initialize" -eq "1" ]; then
          compinit
          compdump
        else
          compinit -C
        fi
      }
      _compinit
    '';

    # 関数は autoload で読み込む
    siteFunctions = {
      # cd したらディレクトリの中身を表示する
      chpwd = ''
        [[ -o interactive && -t 1 ]] || return 0
        pwd
        eza -F --icons
      '';

      precmd = ''
        if [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
          tmux refresh-client -S
        fi
      '';

      fzf-select-history = ''
        local selected_command=$(history -n -r 1 | fzf --no-sort --reverse)
        if [ -n "$selected_command" ]; then
          BUFFER="''${selected_command}"
        fi
      '';

      peco-cdr = ''
        local selected_dir=$(cdr -l | awk '{ print $2 }' | \
          fzf --reverse --ansi --preview 'f() { zsh -c "eza -1 --icons $1" }; f {}')
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

      __source = "source ~/.zshrc";
      __tig = "tig";
      __vim = "nvim";
    };

    # Home Manager に設定項目がない zstyle、cdr の設定、キー割り当てだけをここに書く
    initContent = ''
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # 補完で小文字でも大文字にマッチさせる
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*:default' menu select=1

      # cdr
      autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
      add-zsh-hook chpwd chpwd_recent_dirs
      zstyle ':completion:*' recent-dirs-insert both
      zstyle ':chpwd:*' recent-dirs-default true
      zstyle ':chpwd:*' recent-dirs-max 1000
      zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"

      ${lib.concatMapStringsSep "\n" (w: "zle -N ${w}") widgets}
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: widget: "bindkey ${lib.escapeShellArg key} ${widget}") keybindings
      )}
    '';

    # ログインシェルの起動時に表示する
    loginExtra = ''
      # dotfilesでgitの差分があればメッセージを出力する
      if [ -n "$(git -C ~/dotfiles status --porcelain)" ]; then
        echo "[INFO] dotfilesに差分があります。早めにレポジトリに反映してください。"
      fi

      # Downloads内でのファイル数とサイズを表示
      if [ -d ~/Downloads ]; then
        echo "Downloads内のファイル数: $(find ~/Downloads -type f | wc -l)"
        echo "Downloads内のファイルサイズ: $(du -sh ~/Downloads | awk '{print $1}')"
      fi
    '';
  };

  home.sessionVariables = {
    HOMEBREW_PREFIX = osConfig.homebrew.prefix;
    LC_ALL = "ja_JP.UTF-8";
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    LDFLAGS = "\${LDFLAGS} -L/usr/local/lib";
    CPPFLAGS = "\${CPPFLAGS} -I/usr/local/include";
    PKG_CONFIG_PATH = "\${PKG_CONFIG_PATH} /usr/local/pkgconfig";
    FZF_DEFAULT_OPS = "--extended";
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_GOOGLE_ANALYTICS = "1";
    POWERLINE_COMMAND = "powerline";
  };
}
