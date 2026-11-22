{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    tmux
    tmux-mem-cpu-load
  ];

  home.file = {
    ".tmux.conf".source = pkgs.replaceVars ./.tmux.conf {
      TMUX_PLUGIN_YANK = "${pkgs.tmuxPlugins.yank.rtp}";
      TMUX_PLUGIN_OPEN = "${pkgs.tmuxPlugins.open.rtp}";
      TMUX_PLUGIN_PAIN_CONTROL = "${pkgs.tmuxPlugins."pain-control".rtp}";
      TMUX_PLUGIN_RESURRECT = "${pkgs.tmuxPlugins.resurrect.rtp}";
      TMUX_PLUGIN_BATTERY = "${pkgs.tmuxPlugins.battery.rtp}";
      TMUX_PLUGIN_POWERLINE = "${pkgs.tmuxPlugins.tmux-powerline.rtp}";
    };
  };

  programs.zsh = {
    siteFunctions = {
      # tmux の中ではプロンプトを出すたびにステータスラインを更新する
      precmd = ''
        if [ -n "$TMUX" ]; then
          tmux refresh-client -S
        fi
      '';

      # IDE 風にペインを分割する
      tsplit = ''
        if [ "$#" -eq 0 ]; then
          tmux split-window -v
          tmux split-window -h
          tmux resize-pane -D 15
          tmux select-pane -t 1
        else
          case $1 in
            1)
              tmux split-window -v
              tmux resize-pane -D 15
              tmux select-pane -D
              clear
              ;;
            2)
              tmux split-window -h
              tmux split-window -v
              tmux resize-pane -D 15
              tmux select-pane -t 1
              tmux split-window -v
              tmux select-pane -t 1
              clear
              ;;
            py)
              cd $2
              tmux split-window -v
              tmux split-window -h
              tmux resize-pane -D 15
              tmux select-pane -t 1
              nvim .
              clear
              ;;
            *)
              echo [ERROR] "$1" は設定されていない引数です。
              ;;
          esac
        fi
      '';

      # 既存の tmux セッションを fzf で選んでアタッチする。なければ新しく作る
      tmux-select-session = ''
        local id create_new_session="Create New Session"
        id="$(tmux list-sessions)"
        if [[ -z "$id" ]]; then
          tmux new-session
          return
        fi
        id="$(echo "$id\n''${create_new_session}:" | fzf | cut -d: -f1)"
        if [[ "$id" = "''${create_new_session}" ]]; then
          tmux new-session
        elif [[ -n "$id" ]]; then
          tmux attach-session -t "$id"
        fi
      '';
    };

    # iTerm2 でログインしたときに tmux のセッションを選ぶ
    loginExtra = lib.mkBefore ''
      if [[ $TERM_PROGRAM == iTerm.app && -z $TMUX ]]; then
        tmux-select-session
      fi
    '';
  };

  xdg.configFile = {
    "tmux-powerline" = {
      source = ./powerline;
      recursive = true;
    };
  };
}
