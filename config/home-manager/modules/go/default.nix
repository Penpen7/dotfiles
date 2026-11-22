{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    golangci-lint
    golangci-lint-langserver
    gotools
    (lib.hiPrio gopls)
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
  };
}
