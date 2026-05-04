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
      require("lsp-progress").setup()

      require("lualine").setup({
        options = {
          theme = "nord",
          section_separators = { "", "" },
          component_separators = { "", "" },
          icons_enabled = true,
        },
        sections = {
          lualine_c = {
            "filename",
            function()
              return require("lsp-progress").progress()
            end,
          },
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern  = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
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
