return ({
  {
    'stevearc/aerial.nvim',
    dir = "@aerialNvim@",
    opts = {},
    -- Optional dependencies
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", dir = "@nvimTreesitter@" },
      { "nvim-tree/nvim-web-devicons",     dir = "@nvimWebDevicons@" },
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end
      }
      )
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dir = "@nvimTreesitter@",
    version = false,
    event = { "CursorHold", "CursorHoldI" },
    config = function()
      require("nvim-treesitter.config").setup({
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
    dir = "@rainbowDelimitersNvim@",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { "lukas-reineke/indent-blankline.nvim", dir = "@indentBlanklineNvim@", main = "ibl", opts = {} },
})
