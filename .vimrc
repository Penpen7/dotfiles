set tabstop=2
set wildmenu wildmode=list:longest,full
set number
set fenc=utf-8
set cursorline
set cursorcolumn
set showmatch
set matchtime=1
syntax on
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
if has('vim_starting')
    " 初回起動時のみruntimepathにNeoBundleのパスを指定する
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/

    " NeoBundleが未インストールであればgit cloneする・・・・・・①
    if !isdirectory(expand("$HOME/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        call system("git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('$HOME/.vim/bundle/'))

" インストールするVimプラグインを以下に記述
" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
"----------------------------------------------------------
" ここに追加したいVimプラグインを記述する・・・・・・②
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'cohama/lexima.vim'
NeoBundle 'munshkr/vim-tidal'
"NeoBundle 'jacoborus/tender.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'surround.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'justmao945/vim-clang'
NeoBundle 'mattn/sonictemplate-vim'
" git
NeoBundle 'tpope/vim-fugitive'
" comment
NeoBundle 'tomtom/tcomment_vim'

NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'


"----------------------------------------------------------
call neobundle#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定・・・・・・③
NeoBundleCheck  
"if neobundle#is_installed('molokai') " molokaiがインストールされていれば
"    colorscheme molokai " カラースキームにmolokaiを設定する
"endif
" If you have vim >=8.0 or Neovim >= 0.1.5
"if (has("termguicolors"))
" set termguicolors
"endif

" For Neovim 0.1.3 and 0.1.4
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Theme
"syntax enable
"colorscheme tender
"let g:lightline = { 'colorscheme': 'tender' }
"let g:airline_theme = 'tender'
"let macvim_skip_colorscheme=1
set laststatus=2
set showtabline=2 " 常にタブラインを表示
set t_Co=256 " この設定がないと色が正しく表示されない
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='papercolor' "落ち着いた色調が好き
let g:airline_powerline_fonts = 1
set t_Co=256 " iTerm2など既に256色環境なら無くても良い
set ttimeoutlen=50

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
  autocmd BufWritePost *.cpp :!g++ -std=c++14 %:p
augroup END




" smart indent when entering insert mode with i on empty lines
function! IndentWithI()
    if len(getline('.')) == 0
        return "cc"
    else
        return "i"
    endif
endfunction
nnoremap <expr> i IndentWithI()
nnoremap <Space>t :Template 
nnoremap <silent> <Space>w :<C-u>w<CR>
nnoremap <Space>s :source $HOME/.vimrc<CR>
nnoremap <Space>v :e $HOME/.vimrc<CR>
nnoremap <Space>q :q<CR>
nnoremap Q <Nop>

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]`


let g:sonictemplate_vim_template_dir = [
      \ '$HOME/template'
      \]

