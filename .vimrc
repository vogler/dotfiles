" https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" https://github.com/tpope/vim-sensible
set undodir^=~/.vim/undo
"set backupdir=~/.vim/backup

" https://github.com/altercation/vim-colors-solarized
syntax enable
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized


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
set relativenumber
"set undofile

nnoremap / /\v
vnoremap / /\v
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
nmap tn :tabnew<CR>


""""""""" ü = :shell """""""""""""""""""""
nmap ü :shell<cr>


""""""""" buffer magic """""""""""""""""""
nmap bn :bn!<cr>
nmap bp :bp!<cr>
nmap bd :bd<cr>


""""""""" ó,ö = y/p with clipboard """""""""
vmap ó "+y
nmap ó viwó             " Y already used in normal mode
map ö "+gP


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
