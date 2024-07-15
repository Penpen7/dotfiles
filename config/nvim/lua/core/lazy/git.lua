return (
  {
    {
      "iberianpig/tig-explorer.vim",
      config = function()
        vim.api.nvim_set_keymap("n", "<Space>g", "<cmd>Tig<CR>", { noremap = true, silent = true })
      end,
      dependencies = { "bclose.vim" },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "CursorHold", "FocusLost" },
      config = function()
        require("gitsigns").setup()
      end,
    },
  }
)
