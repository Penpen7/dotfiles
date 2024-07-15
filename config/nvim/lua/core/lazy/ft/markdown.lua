return (
  {
    {
      "iamcco/markdown-preview.nvim",
      ft = { "markdown", "pandoc.markdown", "rmd", "plantuml" },
      build = 'sh -c "cd app && yarn install"',
      config = function()
        vim.g.mkdp_filetypes = { "markdown", "plantuml" }
      end,
    },
    {
      "plasticboy/vim-markdown",
      ft = { "markdown" },
      config = function()
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_new_list_item_indent = 0
      end,
    },
  }
)
