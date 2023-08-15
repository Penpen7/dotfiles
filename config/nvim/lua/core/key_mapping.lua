vim.api.nvim_set_keymap("n", "<Space>w", ":w<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Space>v", ":e $HOME/.config/nvim<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Space>c", ":!oj t<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Space>t", ":bo terminal", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<Space>q", ":q<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<F4>", ":<C-u>setlocal relativenumber!<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("", "<ESC><ESC>", ":nohl<CR>", {})
vim.api.nvim_set_keymap("n", "j", "gj", {})
vim.api.nvim_set_keymap("n", "k", "gk", {})
vim.api.nvim_set_keymap("n", "n", "nzz", {})
vim.api.nvim_set_keymap("n", "N", "Nzz", {})
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", {})
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", {})
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", {})
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", {})
vim.api.nvim_set_keymap("n", "<C-p>", ":bp<CR>", {})
vim.api.nvim_set_keymap("n", "<C-n>", ":bn<CR>", {})
vim.api.nvim_set_keymap("n", "s", '"_s', {})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", '<Esc><Left>"zx"zpa', { silent = true })
vim.api.nvim_set_keymap("v", "p", '"_dP', {})

vim.cmd([[
  filetype plugin indent on
]])
vim.cmd([[
  autocmd FileType typescript setlocal omnifunc=lsp#complete
]])
function IndentWithI()
	if #getline(".") == 0 then
		return "cc"
	else
		return "i"
	end
end
vim.cmd([[
  command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
]])
vim.cmd([[
  autocmd TermOpen * startinsert
]])
vim.cmd([[
  augroup vimrcEx
    autocmd!
    autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" | endif
  augroup END
]])
