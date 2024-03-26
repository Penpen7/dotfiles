#!/bin/bash
set -e
editors=(nvim vim)
languages=(python3 python go terraform gcc deno)
lsp=(terraform-ls bash-language-server)
formatter=(shfmt)
dev_tool=(gcc tig)
tool=(fzf ytop eza bat tmux nkf wget jq imagemagick gnuplot)

for i in ${editors[@]}; do
  which $i
done
for i in ${languages[@]}; do
  which $i
done
for i in ${lsp[@]}; do
  which $i
done
for i in ${formatter[@]}; do
  which $i
done
