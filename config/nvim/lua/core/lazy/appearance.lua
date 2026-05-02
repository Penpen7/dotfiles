return {
  {
    "shaunsingh/nord.nvim",
    dir = "@nordNvim@",
    config = function()
      vim.g.nord_disable_background = true
      vim.cmd [[colorscheme nord]]
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dir = "@lualineNvim@",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", dir = "@nvimWebDevicons@" },
      { "linrongbin16/lsp-progress.nvim", dir = "@lspProgressNvim@" },
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "nord",
          section_separators = { "", "" },
          component_separators = { "", "" },
          icons_enabled = true,
        },
      })
    end,
  },
  -- "rickhowe/diffchar.vim",
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   opts = {
  --     stiffness = 0.5,
  --     trailing_stiffness = 0.49,
  --   },
  -- },
}
