set tabstop=2
set wildmenu wildmode=list:longest,full
set number
set fenc=utf-8
set cursorline
set cursorcolumn
set showmatch
set matchtime=1
set autoindent
set ruler
set shiftwidth=2
set expandtab
set mouse=a

if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
" vimrc に以下のように追記

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
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

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~')
  let s:toml      = g:rc_dir . '/.dein.toml'
  let s:lazy_toml = g:rc_dir . '/.dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" オムニ補完設定
autocmd FileType typescript setlocal omnifunc=lsp#complete
set background=dark
set laststatus=2
set showtabline=2 " 常にタブラインを表示
set t_Co=256 " この設定がないと色が正しく表示されない
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='papercolor' "落ち着いた色調が好き
let g:airline_powerline_fonts = 1
set t_Co=256 " iTerm2など既に256色環境なら無くても良い
set ttimeoutlen=50
set background=dark

"set showmode
"set showcmd
set ruler
set backspace=indent,eol,start
nnoremap <silent><C-e> :NERDTreeToggle<CR>
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

augroup setAutoCompile
  autocmd!
  autocmd BufWritePost *.cpp :!g++ -std=c++14 -g -O0 -D_DEBUG %:p
augroup END
augroup allFiles
  autocmd!
  autocmd BufWritePost * : :Autoformat
augroup END


let fortran_free_source=1
let fortran_have_tabs=1
let fortran_more_precise=1
let fortran_do_enddo=1


" smart indent when entering insert mode with i on empty lines
function! IndentWithI()
  if len(getline('.')) == 0
    return "cc"
  else
    return "i"
  endif
endfunction
nnoremap <expr> i IndentWithI()
nnoremap <Space>t :Template<Space>
nnoremap <silent> <Space>w :<C-u>w<CR>
nnoremap <Space>s :source $HOME/.vimrc<CR>
nnoremap <Space>v :e $HOME/.vimrc<CR>
nnoremap <Space>o :e
nnoremap <Space>q :q<CR>
nnoremap Q <Nop>

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]`


let g:sonictemplate_vim_template_dir = [
      \ '$HOME/template'
      \]

" 補完

set completeopt=menuone,noinsert

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"
noremap <F3> :Autoformat<CR>
    let g:formatdef_mycustom_cpp = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=\"{BasedOnStyle: Google, AlignTrailingComments: true, '.(&textwidth ? 'ColumnLimit: '.&textwidth.', ' : '').(&expandtab ? 'UseTab: Never, IndentWidth: '.shiftwidth() : 'UseTab: Always').'}\"'"
let g:formatters_cpp = ['mycustom_cpp']
