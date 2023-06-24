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
    vim.cmd[[colorscheme gruvbox]]
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
})
