local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

lazy.setup({
  {
    "morhetz/gruvbox",
    config = function()
      vim.g.airline_powerline_fonts = 1
      vim.g.gruvbox_contrast_dark = "medium"
      vim.g.gruvbox_transparent_bg = 1
      vim.api.nvim_create_augroup("gruvbox", {
        clear = true
      })
      vim.api.nvim_create_autocmd("SourcePost", {
        group = "gruvbox",
        callback = function()
          vim.cmd("highlight Normal     ctermbg=NONE guibg=NONE")
          vim.cmd("highlight LineNr     ctermbg=NONE guibg=NONE")
          vim.cmd("highlight SignColumn ctermbg=NONE guibg=NONE")
        end,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  "tpope/vim-endwise",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tomtom/tcomment_vim",
  {
    "github/copilot.vim",
    event = { "InsertEnter", "CursorHold", "CursorHoldI" },
    config = function()
      vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
    end
  },
  "rickhowe/diffchar.vim",
  "dhruvasagar/vim-table-mode",
  "machakann/vim-highlightedyank",
  "godlygeek/tabular",
  "rbgrouleff/bclose.vim",
  {
    "mbbill/undotree",
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>u", "[undotree-p]", {})
      vim.api.nvim_set_keymap("n", "[undotree-p]", ":UndotreeToggle<CR>", { noremap = true })
    end,
  },
  {
    "phaazon/hop.nvim",
    keys = { "<leader><leader>" },
    setup = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "<Leader><Leader>", "[hop]", {})
      vim.api.nvim_set_keymap("x", "<Leader><Leader>", "[hop]", {})
      vim.api.nvim_set_keymap("n", "[hop]w", ":HopWord<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "[hop]l", ":HopLine<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "[hop]f", ":HopChar1<CR>", { silent = true, noremap = true })
    end,
  },
  { "folke/neoconf.nvim",     cmd = "Neoconf" },
  "folke/neodev.nvim",
  { "diepm/vim-rest-console", ft = "rest" },
  { "hashivim/vim-terraform", ft = "tf" },
  { "aklt/plantuml-syntax",   ft = "plantuml" },
  {
    "lewis6991/gitsigns.nvim",
    event = { "CursorHold", "FocusLost" },
    config = function()
      require("gitsigns").setup()
    end,
  },
  { "lambdalisue/nerdfont.vim",               event = { "CursorHold", "FocusLost" } },
  { "lambdalisue/fern-renderer-nerdfont.vim", dependencies = "lambdalisue/fern.vim" },
  { "lambdalisue/fern-git-status.vim",        dependencies = "lambdalisue/fern.vim" },
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
    "lambdalisue/fern.vim",
    config = function()
      vim.g["fern#renderer"] = "nerdfont"
      vim.g["fern#default_hidden"] = 1
      vim.api.nvim_set_keymap("n", "<C-e>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-e><C-e", ":Fern .<CR>", { noremap = true })
    end,
  },
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
    "iberianpig/tig-explorer.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "<Space>g", "<cmd>Tig<CR>", { noremap = true, silent = true })
    end,
    dependencies = { "bclose.vim" },
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
    "ryanoasis/vim-devicons",
    config = function()
      vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
    end,
  },
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
  { "junegunn/fzf",    build = "./install --all", merged = 0 },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = "nvim-lua/plenary.nvim",
    keys = { "<leader>f" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fgr', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
      vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})
    end
  },
  "itchyny/calendar.vim",
  { "mattn/emmet-vim", ft = "html" },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    event = { "CursorHold", "CursorHoldI" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "*" },
        ignore_install = { "phpdoc", "swift" },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        autotag = { enable = true },
      })
    end,
  },
  {
    "p00f/nvim-ts-rainbow",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        },
      })
    end,
  },
  {
    "thinca/vim-quickrun",
    config = function()
      if not vim.g.quickrun_config then
        vim.g.quickrun_config = {}
      end
      vim.api.nvim_set_keymap("n", "<Leader>r", ":QuickRun<CR>", { silent = true })
      -- vim.cmd([[
      --       augroup rust_quickrun
      --         autocmd BufNewFile,BufRead *.crs setf rust
      --         autocmd BufNewFile,BufRead *.py  let g:quickrun_config.python = {'command' : 'python3'}
      --         autocmd BufNewFile,BufRead *.rs  let g:quickrun_config.rust = {'exec' : 'cargo run'}
      --         autocmd BufNewFile,BufRead *.crs let g:quickrun_config.rust = {'exec' : 'cargo script %s -- %a'}
      --       augroup END
      --       ]])
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd", "plantuml" },
    build = 'sh -c "cd app && yarn install"',
    config = function()
      vim.g.mkdp_filetypes = { "markdown", "plantuml" }
    end,
  },
  {
    "mattn/sonictemplate-vim",
    config = function()
      vim.g.sonictemplate_vim_template_dir = { "$HOME/template" }
      vim.api.nvim_set_keymap("n", "<Space>y", ":e $HOME/template/cpp<CR>", {})
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
  {
    "Penpen7/IMEswitcher.nvim",
    build = "make",
    events = { "InsertEnter", "InsertLeave" },
    config = function()
      if vim.fn.has("mac") == 1 then
        vim.api.nvim_create_augroup("IMEswitcher", { clear = true })
        vim.api.nvim_create_autocmd("InsertLeave",
          { group = "IMEswitcher", pattern = "*", command = "call IMEswitcher#InsertLeave()" })
        vim.api.nvim_create_autocmd("InsertEnter",
          { group = "IMEswitcher", pattern = "*", command = "call IMEswitcher#InsertEnter()" })
      end
    end,
  },
  "dstein64/vim-startuptime",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          section_separators = { "", "" },
          component_separators = { "", "" },
          icons_enabled = true,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    tag = "legacy",
    requires = { "neovim/nvim-lspconfig" }
  },
  "nvim-tree/nvim-web-devicons",
  {
    "kdheepak/tabline.nvim",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    config = function()
      require("tabline").setup({
        -- Defaults configuration options
        enable = true,
        options = {
          -- If lualine is installed tabline will use separators configured in lualine by default.
          -- These options can be used to override those settings.
          section_separators = { "", "" },
          component_separators = { "", "" },
          max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
          show_tabs_always = false,    -- this shows tabs only when there are more than one tab or if the first tab is named
          show_devicons = true,        -- this shows devicons in buffer section
          show_bufnr = false,          -- this appends [bufnr] to buffer section,
          show_filename_only = false,  -- shows base filename only instead of relative path in filename
          modified_icon = "+ ",        -- change the default modified icon
          modified_italic = false,     -- set to true by default; this determines whether the filename turns italic if modified
          show_tabs_only = false,      -- this shows only tabs instead of tabs + buffers
        },
      })
      if vim.fn.has("gui_running") == 1 then
        if pcall(has_guioptions) then
          vim.opt.guioptions:remove("e")
        end
      end
      vim.opt.sessionoptions:append("tabpages,globals")
    end,
    requires = { { "hoob3rt/lualine.nvim", opt = true }, { "kyazdani42/nvim-web-devicons", opt = true } },
  },
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    config = function()
      local mason = require("mason-lspconfig")
      mason.setup({
        ensure_installed = {
          -- "hadolint",
          "docker_compose_language_service",
          "dockerls",
          "bashls",
          "eslint",
          -- "goimports",
          -- "golangci-lint",
          "gopls",
          "lua_ls",
          -- "prettier",
          "rust_analyzer",
          -- "rustfmt",
          -- "shellcheck",
          -- "shfmt",
          -- "stylua",
          "terraformls",
          "tsserver",
        },
      })
      mason.setup_handlers({
        function(server)
          local opt = {
            on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true }
              vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
              vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fmt", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
              vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
              vim.api.nvim_buf_set_keymap(
                bufnr,
                "n",
                "<space>r",
                "<cmd>lua vim.lsp.buf.rename()<CR>",
                opts
              )
              vim.api.nvim_buf_set_keymap(
                bufnr,
                "n",
                "<space>h",
                "<cmd>lua vim.lsp.buf.hover()<CR>",
                opts
              )
            end,
            capabilities = require("cmp_nvim_lsp").default_capabilities(
              vim.lsp.protocol.make_client_capabilities()
            ),
          }
          require("lspconfig")[server].setup(opt)
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "vsnip" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-l>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        experimental = {
          ghost_text = true,
        },
        -- Lspkind(アイコン)を設定
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          }),
        },
      })
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }, --ソース類を設定
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "buffer" } }, { { name = "cmdline" } }),
      })
    end,
  },
  "hrsh7th/vim-vsnip",
  "hrsh7th/cmp-path",     --pathを補完ソースに
  "hrsh7th/vim-vsnip",    --スニペットエンジン
  "hrsh7th/cmp-vsnip",    --スニペットを補完ソースに
  "hrsh7th/cmp-cmdline",  --コマンドラインを補完ソースに
  "hrsh7th/cmp-buffer",   --bufferを補完ソースに
  "hrsh7th/cmp-nvim-lsp",
  "onsails/lspkind.nvim", --補完欄にアイコンを表示
})
