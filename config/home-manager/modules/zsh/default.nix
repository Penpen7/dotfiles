{ pkgs, lib, ... }:
let
  fzfDir = ../../../fzf;
in
{
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

    initContent = lib.mkMerge [
      # PATH (後から追加したものほど優先される)
      (lib.mkOrder 505 ''
        export PATH="$HOMEBREW_PREFIX/bin":$PATH
        export PATH="$HOMEBREW_PREFIX/sbin":$PATH
        export PATH="$GOPATH/bin":$PATH
        export PATH="$HOME/.cargo/bin:"$PATH
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.bun/bin:$PATH"

        # Nix (最後に追加することで優先される)
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        if [ -d "/etc/profiles/per-user/$USER/bin" ]; then
          export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
        fi
      '')

      (lib.mkOrder 550 ''
        eval "$(${pkgs.coreutils}/bin/dircolors -b ${./nord.dircolors})"
        if [ -n "$LS_COLORS" ]; then
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        fi
      '')

      # 関数の中でもエイリアスが展開されるよう、エイリアス定義 (1100) より後に読み込む
      (lib.mkOrder 1110 ''
        # 補完で小文字でも大文字にマッチさせる
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        zstyle ':completion:*:default' menu select=1

        # taskコマンドがある場合のみ補完を有効にする
        if (( $+commands[task] )); then
          eval "$(task --completion zsh)"
        fi

        source ${./shortcut.zsh}
        source ${fzfDir + "/zsh.zsh"}
        source ${fzfDir + "/ghq.zsh"}
        source ${fzfDir + "/docker.zsh"}
      '')

      # ウィジェット名の登録とキー割り当ては、関数を読み込んだあとに行う
      (lib.mkOrder 1120 ''
        source ${./keybind.zsh}
      '')

      (lib.mkAfter ''
        # dotfilesでgitの差分があればメッセージを出力する
        if [ -n "$(git -C ~/dotfiles status --porcelain)" ]; then
          echo "[INFO] dotfilesに差分があります。早めにレポジトリに反映してください。"
        fi

        # Downloads内でのファイル数とサイズを表示
        function download_info() {
          # Downloadsが存在しない場合は何もしない
          if [ ! -d ~/Downloads ]; then
            return
          fi
          echo "Downloads内のファイル数: $(find ~/Downloads -type f | wc -l)"
          echo "Downloads内のファイルサイズ: $(du -sh ~/Downloads | awk '{print $1}')"
        }

        download_info

        function precmd() {
          if [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
            tmux refresh-client -S
          fi
        }
      '')
    ];
  };

  home.sessionVariables = {
    HOMEBREW_PREFIX = "/opt/homebrew";
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
