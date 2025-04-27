return {
  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_disable_background = true
      vim.cmd [[colorscheme nord]]
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
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
  "rickhowe/diffchar.vim",
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.49,
    },
  },
}
