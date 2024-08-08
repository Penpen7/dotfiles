return ({
  {
    "lambdalisue/fern.vim",
    config = function()
      vim.g["fern#renderer"] = "nerdfont"
      vim.g["fern#default_hidden"] = 1
      vim.api.nvim_set_keymap("n", "<C-e>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-e><C-e", ":Fern .<CR>", { noremap = true })
    end,
  },
  { "lambdalisue/fern-renderer-nerdfont.vim", dependencies = "lambdalisue/fern.vim" },
  { "lambdalisue/fern-git-status.vim",        dependencies = "lambdalisue/fern.vim" },
  { "lambdalisue/nerdfont.vim", },
  "nvim-tree/nvim-web-devicons",
  {
    "lambdalisue/glyph-palette.vim",
    config = function()
      vim.cmd([[
        augroup my-glyph-palette
          autocmd! *
          autocmd FileType fern call glyph_palette#apply()
          autocmd FileType nerdtree,startify call glyph_palette#apply()
        augroup END
    ]])
    end,
  },
  {
    "ryanoasis/vim-devicons",
    config = function()
      vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local highlights = require("nord").bufferline.highlights({
        italic = true,
        bold = true,
        fill = "#181c24"
      })

      require("bufferline").setup({
        options = {
          separator_style = "slant",
        },
        highlights = highlights,
      })
    end
  },
  {
    "mbbill/undotree",
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>u", "[undotree-p]", {})
      vim.api.nvim_set_keymap("n", "[undotree-p]", ":UndotreeToggle<CR>", { noremap = true })
    end,
  },
  "itchyny/calendar.vim",
  {
    "vim-test/vim-test",
    keys = { "<Leader>t" },
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>t", "[vim-test]", {})
      vim.api.nvim_set_keymap("x", "<Leader>t", "[vim-test]", {})
      vim.api.nvim_set_keymap("n", "[vim-test]n", ":TestNearest<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "[vim-test]f", ":TestFile<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "[vim-test]s", ":TestSuite<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "[vim-test]l", ":TestLast<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "[vim-test]v", ":TestVisit<CR>", { silent = true })
    end,
  },
  {
    "tyru/open-browser.vim",
    config = function()
      vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
      vim.api.nvim_set_keymap("n", "gx", "<Plug>(openbrowser-smart-search)", {})
      vim.api.nvim_set_keymap("v", "gx", "<Plug>(openbrowser-smart-search)", {})
      vim.api.nvim_set_keymap(
        "n",
        "<Leader>o",
        "<cmd>execute 'OpenBrowser' 'file:///' .. expand('%:p:gs?\\?/?')<CR>",
        { noremap = true }
      )
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      triggers = {
        -- { '<leader>', '[', ']', 'g', 'v', 'c', 'd', 'y', '"', 'z', '<C-w>', '=', '@' }
        { "<leader>", mode = "nixsotc" },
        { "g",        mode = "nixsotc" },
        { "v",        mode = "nixsotc" },
        { "c",        mode = "nixsotc" },
        { "d",        mode = "nixsotc" },
        { "y",        mode = "nixsotc" },
        { '"',        mode = "nixsotc" },
        { "z",        mode = "nixsotc" },
        { "<C-w>",    mode = "nixsotc" },
        { "=",        mode = "nixsotc" },
        { "@",        mode = "nixsotc" },
      }
    }
  },
  "machakann/vim-highlightedyank",
  "rbgrouleff/bclose.vim",
  {
    "phaazon/hop.nvim",
    keys = { "<leader><leader>" },
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "<Leader><Leader>", "[hop]", {})
      vim.api.nvim_set_keymap("x", "<Leader><Leader>", "[hop]", {})
      vim.api.nvim_set_keymap("n", "[hop]w", ":HopWord<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "[hop]l", ":HopLine<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "[hop]f", ":HopChar1<CR>", { silent = true, noremap = true })
    end,
  },
})
