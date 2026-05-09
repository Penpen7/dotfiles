{ pkgs, ... }:
{
  home.packages = with pkgs; [ zsh ];

  home.file = {
    ".zshrc".source = pkgs.replaceVars ./.zshrc {
      zinit = "${pkgs.zinit}/share/zinit";
      zshPowerlevel10k = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      zshAutosuggestions = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      zshFastSyntaxHighlighting = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
      zshCompletions = "${pkgs.zsh-completions}/share/zsh/site-functions";
    };
    ".zshenv".source = ./.zshenv;
  };

  programs.zsh.enable = true;
}
