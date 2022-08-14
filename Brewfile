tap "cjbassi/ytop"
tap "hashicorp/tap"
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
brew "coreutils"
brew "gcc"
brew "python@3.9"
brew "exa"
brew "nodebrew"
brew "neovim"
brew "zsh"
brew "fzf"
brew "deno"

if (!(OS.mac?)) || ENV["CI"] != "1"
  brew "git"
  brew "go"
  brew "golangci-lint"
end

if ENV["CI"] != "1"
  brew "awscli"
  brew "bat"
  brew "cmake"
  brew "ffmpeg"
  brew "ghq"
  brew "gnupg"
  brew "pango"
  brew "gnuplot"
  # brew "graphviz"
  brew "grex"
  brew "hub"
  brew "imagemagick"
  brew "jq"
  brew "lazygit"
  brew "llvm"
  brew "mas"
  brew "mdcat"
  brew "nkf"
  brew "ripgrep"
  brew "terraform"
  brew "terraform-ls"
  brew "tig"
  brew "tmux"
  brew "wget"
  brew "zsh-completions"
  brew "cjbassi/ytop/ytop"
  cask "adobe-acrobat-reader"
  cask "alacritty"
  cask "audacity"
  cask "chromedriver"
  cask "cool-retro-term"
  cask "font-hackgen"
  cask "font-hackgen-nerd"
  cask "iterm2"
  cask "keycastr"
  cask "kitty"
  cask "mactex"
  cask "slack"
  cask "visual-studio-code"
end

if OS.mac? && ENV["CI"] != "1"
  mas "AmorphousDiskMark", id: 1168254295
  mas "GeoGebra Classic 6", id: 1182481622
  mas "LINE", id: 539883307
  mas "Logic Pro", id: 634148309
  mas "Magnet", id: 441258766
  mas "Pages", id: 409201541
  mas "PicGIF Lite", id: 844918735
  mas "Skitch", id: 425955336
  mas "Xcode", id: 497799835
end
