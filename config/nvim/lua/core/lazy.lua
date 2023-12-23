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
    event = "VimEnter",
    config = function()
      vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
    end
  },
  "rickhowe/diffchar.vim",
  { "dhruvasagar/vim-table-mode", event = { "InsertEnter" } },
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
  { "folke/neoconf.nvim",         cmd = "Neoconf" },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
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
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
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
  {
    'neoclide/coc.nvim',
    branch = 'master',
    build = 'yarn install --frozen-lockfile',
    config = function()
      -- Coc.nvimの設定
      vim.cmd([[
  let g:coc_global_extensions = ['coc-word', 'coc-diagnostic', 'coc-tsserver', 'coc-rust-analyzer', 'coc-json', 'coc-jedi', 'coc-go', 'coc-clangd', 'coc-json', 'coc-css', 'coc-cssmodules', 'coc-toml', 'coc-yaml', 'coc-sql', 'coc-snippets', 'coc-tabnine', 'coc-pairs']
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  "スペースhでHover
  nmap <silent> <space>h :call CocAction('doHover')<CR>
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> <space>fmt <Plug>(coc-format)
  nmap <silent> <space>r <Plug>(coc-rename)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  inoremap <silent><expr> <c-space> coc#refresh()

  autocmd CursorHold * silent call CocActionAsync('highlight')
            ]])
    end
  }
})
