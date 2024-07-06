vim.g.loaded_matchit = true
vim.o.laststatus = 2
vim.o.tabstop = 2
vim.o.wildmenu = true
vim.o.wildmode = "list:longest,full"
vim.o.number = true
vim.o.fenc = "utf-8"
vim.o.showmatch = true
vim.o.matchtime = 1
vim.o.autoindent = true
vim.o.ruler = true
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.mouse = "n"
vim.o.ttimeoutlen = 50
vim.o.ruler = true
vim.o.backspace = "indent,eol,start"
vim.o.showtabline = 2
vim.o.matchtime = 1
vim.o.display = "lastline"
vim.o.expandtab = true
vim.o.relativenumber = true
vim.o.inccommand = "split"
vim.o.shortmess = vim.o.shortmess .. "I"
vim.o.listchars = "tab:>-"
vim.o.list = true
vim.o.fileencodings = "utf-8,sjis,cp932"
vim.o.fileformats = "unix,dos,mac"
vim.o.fixendofline = true
vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
vim.cmd([[
  set scroll=3
  au BufEnter set scroll=3
]])
if vim.fn.has("gui_running") == 1 then
	if pcall(has_guioptions) then
		vim.opt.guioptions:remove({
			"m", -- hide menu bar
			"T", -- hide toolbar
			"L", -- hide left-hand scrollbar
			"r", -- hide right-hand scrollbar
			"R",
			"l",
			"b", -- hide bottom scrollbar
		})
	end
end
