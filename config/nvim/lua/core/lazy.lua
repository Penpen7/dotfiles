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
  { "lambdalisue/nerdfont.vim", },
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
      vim.g.coc_global_extensions = {
        'coc-word', 'coc-diagnostic', 'coc-tsserver', 'coc-rust-analyzer', 'coc-json', 'coc-jedi', 'coc-go',
        'coc-clangd',
        'coc-json', 'coc-css', 'coc-cssmodules', 'coc-toml', 'coc-yaml', 'coc-sql', 'coc-snippets', 'coc-tabnine',
        'coc-pairs',
        'coc-lua'
      }
      -- Some servers have issues with backup files, see #649
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
      -- delays and poor user experience
      vim.opt.updatetime = 300

      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appeared/became resolved
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })


      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })


      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })


      -- Symbol renaming
      keyset("n", "<space>r", "<Plug>(coc-rename)", { silent = true })


      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s)."
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder"
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply source code actions for current file.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })


      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline
      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true }
      -- Show all diagnostics
      keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
      -- Manage extensions
      keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
      -- Show commands
      keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
      -- Find symbol of current document
      keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
      -- Search workspace symbols
      keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
      -- Do default action for next item
      keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
      -- Do default action for previous item
      keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
      -- Resume latest coc list
      keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

      -- coc-htmlがうまく動作しないので、htmlファイルの時はcoc-navを無効にする
      vim.api.nvim_create_augroup("CocNavToggle", { clear = true })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = "CocNavToggle",
        pattern = "*.html",
        command = "call CocActionAsync('deactivateExtension', 'coc-nav')",
        desc = "Turn off coc-nav for html"
      })

      vim.api.nvim_create_autocmd("BufLeave", {
        group = "CocNavToggle",
        pattern = "*.html",
        command = "call CocActionAsync('toggleExtension', 'coc-nav')",
        desc = "Turn on coc-nav for other files"
      })

      -- auto import for golang
      vim.api.nvim_create_augroup("Organize Import", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "CocNavToggle",
        pattern = "*.go",
        command = "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
        desc = "Organize Import"
      })
    end
  }
})
