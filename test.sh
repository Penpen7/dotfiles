#!/bin/bash
set -e
editors=(nvim vim)
languages=(python3 python go terraform gcc deno)
lsp=(terraform-ls bash-language-server)
dev_tool=(gcc tig)
tool=(fzf ytop exa bat tmux nkf wget jq imagemagick gnuplot)

for i in ${editors[@]}
do
  which $i
done
for i in ${languages[@]}
do
  which $i
done
for i in ${lsp[@]}
do
  which $i
done
