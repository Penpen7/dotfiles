return (
  {
    {
      "iberianpig/tig-explorer.vim",
      dir = "@tigExplorer@",
      config = function()
        vim.api.nvim_set_keymap("n", "<Space>g", "<cmd>Tig<CR>", { noremap = true, silent = true })
      end,
      dependencies = { "bclose.vim" },
    },
    {
      "lewis6991/gitsigns.nvim",
      dir = "@gitsignsNvim@",
      event = { "CursorHold", "FocusLost" },
      config = function()
        require("gitsigns").setup()
      end,
    },
  }
)
