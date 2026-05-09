{ pkgs, ... }:
{
  home.file = {
    "Library/Application Support/Code/User/settings.json".source = pkgs.replaceVars ./settings.json {
      neovim = pkgs.neovim;
    };
    "Library/Application Support/Code/User/keybindings.json".source = ./keybindings.json;
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      asvetliakov.vscode-neovim
      github.copilot-chat
      golang.go
      hashicorp.terraform
      jdinhlife.gruvbox
      jebbs.plantuml
      mhutchie.git-graph
      ms-azuretools.vscode-containers
      ms-azuretools.vscode-docker
      ms-ceintl.vscode-language-pack-ja
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-python.vscode-python-envs
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vsliveshare.vsliveshare
      ms-vsliveshare.vsliveshare-audio
      vscodevim.vim
    ];
  };
}
