filetype plugin on
filetype indent on

set mouse=a

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
