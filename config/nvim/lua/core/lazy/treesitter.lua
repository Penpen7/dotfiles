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
    event = { "BufRead", "BufNewFile", "CursorHold", "CursorHoldI" },
    init = function()
      for dir in ("@tsParserDirs@"):gmatch("[^,]+") do
        vim.opt.runtimepath:append(dir)
      end
    end,
    config = function()
      local function attach(bufnr)
        pcall(vim.treesitter.start, bufnr)
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      attach(vim.api.nvim_get_current_buf())
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
