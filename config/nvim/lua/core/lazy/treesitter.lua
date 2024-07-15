return ({
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end
      }
      )
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    event = { "CursorHold", "CursorHoldI" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ignore_install = { "phpdoc", "swift" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        }
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
})
