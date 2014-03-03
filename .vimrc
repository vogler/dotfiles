" use vundle instead of vim-pathogen
" https://github.com/gmarik/vundle
set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" somehow these need to be exactly here
Bundle 'kchmck/vim-coffee-script'
Bundle 'digitaltoad/vim-jade'

syntax enable
filetype plugin indent on     " required!

" original repos on github
Bundle 'tpope/vim-sensible'
set undodir^=~/.vim/undo
"set backupdir=~/.vim/backup

Bundle 'altercation/vim-colors-solarized'
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized

Bundle 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

Bundle 'airblade/vim-gitgutter'
"Bundle 'mhinz/vim-signify'
"highlight clear SignColumn

Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'

Bundle 'tpope/vim-commentary'
autocmd FileType ocaml set commentstring=(*\ %s\ *)

Bundle 'Lokaltog/vim-easymotion'
Bundle 'rking/ag.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-endwise'
Bundle 'IndexedSearch'

" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" see :h vundle for more details or wiki for FAQ

" OCaml
" setup merlin, syntastic and ocp-indent
let opam_share=substitute(system('opam config var share'),'\n$','','''')
let s:ocamlmerlin=opam_share . "/ocamlmerlin"
execute "set rtp+=".s:ocamlmerlin."/vim"
execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
let g:syntastic_ocaml_checkers = ['merlin']
nnoremap <localleader> :Locate<cr>
execute 'autocmd FileType ocaml source' opam_share . "/vim/syntax/ocp-indent.vim"

" http://chneukirchen.org/dotfiles/.vimrc
" a selects everything in visual selection mode
vmap a <esc>ggVG

" background, even in insert mode
map! <C-Z> <C-O>:stop<C-M>

" compress whitespace
nmap g<space> :s/\s*\%#\s*/ /e<CR>

" yay
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" save as root
" cmap w!! w !sudo tee % >/dev/null
command! WW :w !sudo tee % >/dev/null


" http://amix.dk/vim/vimrc.html
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>
"map <C-s> :w!<cr>
"map <C-w> :q!<cr>


" https://github.com/nihathrael/configs/blob/master/.vimrc
set viminfo+=!          " support for yanking
set mouse=a             " enable mouse

set nocompatible        " no vi compatibility

"set novisualbell        " no visual beeping
"set noerrorbells        " no noise

set tabstop=4           " 1 tab = 4 spaces
set shiftwidth=4
set softtabstop=4
set expandtab           " tab --> spaces
set autoindent          " indent when starting new line
set smartindent         " smart indent when starting new line
" don't mess up the hashes, e.g. in perl comments
"inoremap # X^H#

set number              " show line numbers
set ruler               " show line,col numbers
set showmatch           " highlight matching braces
set nowrap              " don't wrap lines
set incsearch           " show matches from search immediately
set hlsearch            " actually do show any matches at all

set foldenable          " do fold
set foldmethod=marker   " fold with markers

set wildmenu            " show completion menu in :e with <C-d>

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#why-i-came-back-to-vim
set encoding=utf-8
set scrolloff=3
"set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
"set ruler
set backspace=indent,eol,start
set laststatus=2
" FocusLost only works with gvim -> don't use relativenumber in terminal
if has("gui-running")
    set relativenumber
    "http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
    "http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
    augroup relnum
        autocmd!
        autocmd FocusLost * :set norelativenumber
        autocmd FocusGained * :set relativenumber
        autocmd InsertEnter * :set norelativenumber
        autocmd InsertLeave * :set relativenumber
    augroup END
endif
"set undofile

"nnoremap / /\v
"vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

"set list
"set listchars=tab:▸\ ,eol:¬

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap ; :
"au FocusLost * :wa
inoremap jj <ESC>


""""""""" Show superfluos spaces """""""""
:highlight ExtraWhitespace ctermbg=darkred guibg=darkred
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL


""""""""" tn = :tabnew """""""""""""""""""
"nmap tn :tabnew<CR>


""""""""" ü = :shell """""""""""""""""""""
nmap ü :shell<cr>


""""""""" buffer magic """""""""""""""""""
"nmap bn :bn!<cr>
"nmap bp :bp!<cr>
"nmap bd :bd<cr>


""""""""" ó,ö = y/p with clipboard """""""""
" vmap ó "+y
" nmap ó viwó             " Y already used in normal mode
" map ö "+gP
set clipboard=unnamedplus


""""""""" gp = select pasted text """"""""
nnoremap gp `[v`]


" tab navigation
:map <C-j> :tabprevious<CR>
:map <C-k> :tabnext<CR>
:imap <C-j> <Esc>:tabprevious<CR>i
:imap <C-k> <Esc>:tabnext<CR>i
:map <C-t> :tabnew<Space>
:imap <C-t> <Esc>:tabnew<Space>


"map <M-o> O<ESC>

" Vim as a Python IDE - Martin Brockhaus
" keep selection on indentation
vnoremap < <gv
vnoremap > >gv

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

