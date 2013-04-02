" https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" https://github.com/tpope/vim-sensible

" https://github.com/altercation/vim-colors-solarized
syntax enable
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized


" http://chneukirchen.org/dotfiles/.vimrc
" a selects everything in visual selection mode
vmap a ggVG

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

"set nocompatible        " no vi compatibility

"set novisualbell        " no visual beeping
"set noerrorbells        " no noise

set tabstop=4           " 1 tab = 4 spaces
set shiftwidth=4
set softtabstop=4
set expandtab           " tab --> spaces
set autoindent          " indent when starting new line
set smartindent         " smart indent when starting new line
" don't mess up the hashes, e.g. in perl comments
inoremap # X^H#

set number              " show line numbers
set ruler               " show line,col numbers
set showmatch           " highlight matching braces
set nowrap              " don't wrap lines
set incsearch           " show matches from search immediately
set hlsearch            " actually do show any matches at all

set foldenable          " do fold
set foldmethod=marker   " fold with markers

set wildmenu            " show completion menu in :e with <C-d>


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


""""""""" Y,ö = y/p with clipboard """""""""
nmap Y "+y
vmap Y "+y
nmap ö "+gP
vmap ö "+gP


""""""""" gp = select pasted text """"""""
nnoremap gp `[v`]


" tab navigation
:map <C-j> :tabprevious<CR>
:map <C-k> :tabnext<CR>
:imap <C-j> <Esc>:tabprevious<CR>i
:imap <C-k> <Esc>:tabnext<CR>i
:map <C-t> :tabnew<Space>
:imap <C-t> <Esc>:tabnew<Space>

