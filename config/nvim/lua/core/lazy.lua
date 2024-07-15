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

local appearance = require("core/lazy/appearance")
local ui = require("core/lazy/ui")
local treesitter = require("core/lazy/treesitter")
local lsp = require("core/lazy/lsp")
local edit = require("core/lazy/edit")
local git = require("core/lazy/git")
local fzf = require("core/lazy/fzf")
local utils = require("core/lazy/utils")
local ft = require("core/lazy/ft")

lazy.setup({
  appearance,
  ui,
  treesitter,
  lsp,
  edit,
  git,
  fzf,
  utils,
  ft
})
