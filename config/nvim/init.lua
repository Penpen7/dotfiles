require('core')
require('key_mapping')
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

require("lazy").setup({
  "folke/which-key.nvim",
  {"morhetz/gruvbox", config = function()
    vim.cmd[[
let g:airline_powerline_fonts = 1
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_transparent_bg = 1
autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
        \ |    highlight LineNr     ctermbg=NONE guibg=NONE
        \ |    highlight SignColumn ctermbg=NONE guibg=NONE
    colorscheme gruvbox]]
  end
  },
  "tpope/vim-endwise",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tomtom/tcomment_vim",
  "github/copilot.vim",
  "SirVer/ultisnips",
  "honza/vim-snippets",
  "rickhowe/diffchar.vim",
  "dhruvasagar/vim-table-mode",
  "machakann/vim-highlightedyank",
  "godlygeek/tabular",
  "rbgrouleff/bclose.vim",
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("mason").setup()
    end,
  },
  {'williamboman/mason-lspconfig.nvim', 
    config = function() 
      require("mason-lspconfig").setup() 
    end
  },
  'neovim/nvim-lspconfig',
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/nvim-cmp",
  {"mbbill/undotree", config = function() 
    vim.api.nvim_set_keymap("n", "<Leader>u", "[undotree-p]", {})
    vim.api.nvim_set_keymap("n", "[undotree-p]", ":UndotreeToggle<CR>", {noremap=true})
    end
  },
  { "phaazon/hop.nvim", config = function()
    require('hop').setup() 
    vim.api.nvim_set_keymap("n", "<Leader><Leader>", "[hop]", {})
    vim.api.nvim_set_keymap("x", "<Leader><Leader>", "[hop]", {})
    vim.api.nvim_set_keymap("n", "[hop]w", ":HopWord<CR>", {silent=true, noremap=true})
    vim.api.nvim_set_keymap("n", "[hop]l", ":HopLine<CR>", {silent=true, noremap=true})
    vim.api.nvim_set_keymap("n", "[hop]f", ":HopChar1<CR>", {silent=true, noremap=true})
  end  
  },
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  "diepm/vim-rest-console",
  {  "hashivim/vim-terraform", ft="tf"},
  "aklt/plantuml-syntax",
  {"lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup()end},
  "lambdalisue/nerdfont.vim",
  {"lambdalisue/fern-renderer-nerdfont.vim", dependencies="lambdalisue/fern.vim"},
  {"lambdalisue/fern-git-status.vim", dependencies="lambdalisue/fern.vim"},
  {"lambdalisue/glyph-palette.vim", config=function()
    vim.cmd[[
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
    ]]
  end
  },
{  "lambdalisue/fern.vim", config=function()
    vim.cmd[[
let g:fern#default_hidden=1
let g:fern#renderer = 'nerdfont'
    ]]
  vim.api.nvim_set_keymap("n", "<C-e>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", {noremap=true})
  vim.api.nvim_set_keymap("n", "<C-e><C-e", ":Fern .<CR>", {noremap=true})

end},
{
  'vim-test/vim-test', config=function()
    vim.cmd[[
  nmap <Leader>t [vim-test]
  xmap <Leader>t [vim-test]
  nnoremap <silent> [vim-test]n :TestNearest<CR>
  nnoremap <silent> [vim-test]f :TestFile<CR>
  nnoremap <silent> [vim-test]s :TestSuite<CR>
  nnoremap <silent> [vim-test]l :TestLast<CR>
  nnoremap <silent> [vim-test]v :TestVisit<CR>
    ]]
  end
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
      vim.api.nvim_set_keymap("n", "<Leader>o", "<cmd>execute 'OpenBrowser' 'file:///' .. expand('%:p:gs?\\?/?')<CR>", { noremap = true })
    end,
  },
  {
"liuchengxu/vista.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>v", "<cmd>Vista coc<CR>", { noremap = true, silent = true })
    end,
  },
})
