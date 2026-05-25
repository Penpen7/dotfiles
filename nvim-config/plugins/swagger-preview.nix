{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  name = "swagger-preview.nvim";
  src = pkgs.fetchFromGitHub {
    owner = "vinnymeller";
    repo = "swagger-preview.nvim";
    rev = "42999dd6ad0bbb3e6ca5e857f3fc3c12de014110";
    hash = "sha256-0PmasvfQKBKtqYOoY/CCqVMuku2zSeex3qGK8KVqPE0=";
  };
}
