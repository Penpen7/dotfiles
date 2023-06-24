vim.g.loaded_matchit = true
-- filetype plugin indent on
vim.cmd([[
  autocmd FileType typescript setlocal omnifunc=lsp#complete
]])
function IndentWithI()
  if #getline('.') == 0 then
    return "cc"
  else
    return "i"
  end
end
vim.api.nvim_set_keymap('n', '<Space>w', ':w<CR>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('n', '<Space>v', ':e $HOME/.config/nvim<CR>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('n', '<Space>c', ':!oj t<CR>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('n', '<Space>t', ':bo terminal', {silent=true, noremap=true})
vim.api.nvim_set_keymap('n', '<Space>q', ':q<CR>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('n', '<F4>', ':<C-u>setlocal relativenumber!<CR>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('', '<ESC><ESC>', ':nohl<CR>', {})
vim.api.nvim_set_keymap('n', 'x', '"_x', {})
vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})
vim.api.nvim_set_keymap('n', 'n', 'nzz', {})
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {})
vim.api.nvim_set_keymap('n', '<C-f>', '<C-f>zz', {})
vim.api.nvim_set_keymap('n', '<C-b>', '<C-b>zz', {})
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', {})
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', {})
vim.api.nvim_set_keymap('n', '<C-p>', ':bp<CR>', {})
vim.api.nvim_set_keymap('n', '<C-n>', ':bn<CR>', {})
vim.api.nvim_set_keymap('n', 's', '"_s', {})
vim.cmd([[
  command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
]])
vim.cmd([[
  autocmd TermOpen * startinsert
]])
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {})
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {silent=true})
vim.api.nvim_set_keymap('i', '<C-t>', '<Esc><Left>"zx"zpa', {silent=true})
vim.o.laststatus=2
vim.o.tabstop=2
vim.o.wildmenu=true
vim.o.wildmode='list:longest,full'
vim.o.number=true
vim.o.fenc='utf-8'
vim.o.showmatch=true
vim.o.matchtime=1
vim.o.autoindent=true
vim.o.ruler=true
vim.o.shiftwidth=2
vim.o.expandtab=true
vim.o.mouse=true
vim.o.ttimeoutlen=50
vim.o.ruler=true
vim.o.backspace='indent,eol,start'
vim.o.showtabline=2
vim.o.matchtime=1
vim.o.display='lastline'
vim.o.expandtab=true
vim.o.relativenumber=true
vim.o.inccommand='split'
vim.o.shortmess=vim.o.shortmess..'I'
vim.o.listchars='tab:>-' 
vim.o.list=true
vim.o.fileencodings='utf-8,sjis,cp932'
vim.o.fileformats='unix,dos,mac'
vim.o.nofixendofline=true
vim.o.clipboard=vim.o.clipboard..'unnamedplus'
vim.cmd([[
  set scroll=3
  au BufEnter set scroll=3
]])
if vim.fn.has("gui_running") == 1 then
    if pcall(has_guioptions) then
        vim.opt.guioptions:remove(
            {
                "m", -- hide menu bar
                "T", -- hide toolbar
                "L", -- hide left-hand scrollbar
                "r", -- hide right-hand scrollbar
                "R",
                "l",
                "b", -- hide bottom scrollbar
            }
        )
    end
end
vim.cmd([[
  augroup vimrcEx
    autocmd!
    autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" | endif
  augroup END
]])
vim.cmd([[
  augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call v:lua.auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
      if !isdirectory(a:dir) && (a:force ||
      \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
      endif
    endfunction
  augroup END
]])
