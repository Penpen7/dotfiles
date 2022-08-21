if !exists('g:vscode') 
  " プラグインが実際にインストールされるディレクトリ
  let s:dein_dir = expand('~/.config/nvim/dein')
  " dein.vim 本体
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  " dein.vim がなければ github から落としてくる
  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  endif

  " 設定開始
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#add(s:dein_repo_dir)

    " プラグインリストを収めた TOML ファイル
    " 予め TOML ファイル（後述）を用意しておく
    let g:rc_dir    = expand('~/.config/nvim')
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    " TOML を読み込み、キャッシュしておく
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    let g:dein#enable_notification = 1

    " 設定終了
    call dein#end()
    call dein#save_state()
  endif

  " もし、未インストールものものがあったらインストール
  if dein#check_install()

    call dein#install()
  endif
  " plugin remove check {{{
  let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif
  " }}}
endif

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on
autocmd FileType typescript setlocal omnifunc=lsp#complete

" smart indent when entering insert mode with i on empty lines
function! IndentWithI()
  if len(getline('.')) == 0
    return "cc"
  else
    return "i"
  endif
endfunction

nnoremap <Space>w :w<CR>
nnoremap <Space>v :e $HOME/.config/nvim<CR>
nnoremap <Space>c :!oj t<CR>
nnoremap <Space>t :bo terminal
nnoremap <Space>q :q<CR>
nnoremap <F4> :<C-u>setlocal relativenumber!<CR>
nnoremap <ESC><ESC> :nohl<CR>
nnoremap x "_x
nnoremap j gj
nnoremap k gk
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-p> :bp<CR>
nnoremap <C-n> :bn<CR>
nnoremap x "_x
nnoremap s "_s
command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
autocmd TermOpen * startinsert
tnoremap <Esc> <C-\><C-n>
inoremap <silent> jj <ESC>
inoremap <C-t> <Esc><Left>"zx"zpa

set laststatus=2
set tabstop=2
set wildmenu wildmode=list:longest,full
set number
set fenc=utf-8
set showmatch
set matchtime=1
set autoindent
set ruler
set shiftwidth=2
set expandtab
set mouse=a
set ttimeoutlen=50
set ruler
set backspace=indent,eol,start
set laststatus=2
set showtabline=2 " 常にタブラインを表示
set matchtime=1
set display=lastline
set expandtab
set relativenumber
set inccommand=split
set shortmess+=I " 起動時メッセージ表示しない
set listchars=tab:>-
set list
set fileencodings=utf-8,sjis,cp932
set fileformats=unix,dos,mac
set nofixendofline
set clipboard+=unnamedplus
set scroll=3
au BufEnter set scroll=3

if has('gui')
  set guifont=HackGenNerd:h18
  set guifontwide=HackGenNerd:h18
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set guioptions-=b
endif

" 最後のカーソル位置を覚えておく
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

au FileType go setlocal sw=4 ts=4 sts=4
source $VIMRUNTIME/macros/matchit.vim

if has('persistent_undo')         "check if your vim version supports
  set undodir=$HOME/.config/nvim/undo     "directory where the undo files will be stored
  set undofile                    "turn on the feature
endif