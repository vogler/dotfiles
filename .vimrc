" use neobundle instead of vundle instead of vim-pathogen
" https://github.com/Shougo/neobundle.vim
if 0 | endif " Note: Skip initialization for vim-tiny or vim-small.
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim' " Let NeoBundle manage NeoBundle

" My Bundles here:
NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \     'windows' : 'tools\\update-dll-mingw',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'linux' : 'make',
  \     'unix' : 'gmake',
  \    },
  \ }
NeoBundle 'tpope/vim-sensible'
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
"NeoBundle 'tpope/vim-commentary'
"autocmd FileType ocaml set commentstring=(*\ %s\ *)
"NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree'
map <C-l> :NERDTreeFind<CR>
let NERDTreeMinimalUI=1
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-rsi'
" NeoBundle 'tpope/vim-sleuth'
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent
" set cindent
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'tpope/vim-characterize'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-jdaddy'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-dispatch'

NeoBundle 'wellle/targets.vim'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#branch#format = 'CustomBranchName'
function! CustomBranchName(name)
  if a:name == 'master' | return 'm' | else | return a:name | endif
endfunction
set guifont=Inconsolata\ for\ Powerline:h18'
NeoBundle 'vim-airline/vim-airline-themes'
" NeoBundle 'bling/vim-bufferline'

NeoBundle 'airblade/vim-gitgutter'
set updatetime=750 " terminal vim might have highlighting glitches for low times...

NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'godlygeek/tabular'
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_by_filename = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|_build|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
" let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_user_command = ['.git', 'cd %s && {git ls-files & git ls-files -o --exclude-standard;} | cat', 'find %s -type f']
NeoBundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"
NeoBundle 'sjl/gundo.vim'
" NeoBundle 'bkad/CamelCaseMotion'
NeoBundle 'chaoren/vim-wordmotion'
let g:wordmotion_prefix = '<Leader>'

NeoBundle 'Lokaltog/vim-easymotion'
" map <Leader> <Plug>(easymotion-prefix) " default is <Leader><Leader> to avoid conflicts with other plugins
let g:EasyMotion_smartcase   = 1
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" map <Leader>h <Plug>(easymotion-linebackward)
" map <Leader>l <Plug>(easymotion-lineforward)

" deprecated: https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
NeoBundle 'rking/ag.vim' " try mileszs/ack.vim, mhinz/vim-grepper, jremmen/vim-ripgrep
" let g:agprg="ag --nogroup --nocolor --column"
NeoBundle 'scrooloose/syntastic'
" NeoBundle 'w0rp/ale'
NeoBundle 'IndexedSearch'
autocmd BufReadPre * if getfsize(@%) > 100000 | let b:tagbar_ignore = 1 | endif
NeoBundle 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
let g:tagbar_compact = 1

NeoBundle 'Twinside/vim-hoogle'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'digitaltoad/vim-jade'
" NeoBundle 'jcf/vim-latex'
NeoBundle 'idris-hackers/idris-vim'
NeoBundle 'lambdatoast/elm.vim'
" NeoBundle 'vim-ocaml-conceal'
" NeoBundle 'MLstate/opalang', {'rtp': 'tools/editors/vim/'} " just copy to .vim/ since this rtp option doesn't seem to work, also the repo is huge
" NeoBundle 'typedebugger' " see http://pllab.is.ocha.ac.jp/~asai/TypeDebugger/

" NeoBundle 'git-time-metric/gtm-vim-plugin'
" let g:gtm_plugin_status_enabled = 1
" function! AirlineInit()
"   if exists('*GTMStatusline')
"     call airline#parts#define_function('gtmstatus', 'GTMStatusline')
"     let g:airline_section_b = airline#section#create([g:airline_section_b, ' ', '[', 'gtmstatus', ']'])
"   endif
" endfunction
" autocmd User AirlineAfterInit call AirlineInit()
NeoBundle 'wakatime/vim-wakatime'

 call neobundle#end()
 filetype plugin indent on
 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck

" :NeoBundleList       - lists configured plugins
" :NeoBundleInstall    - installs plugins; append `!` to update or just :NeoBundleUpdate
" :NeoBundleSearch foo - searches for foo; append `!` to refresh local cache
" :NeoBundleClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" Put your non-Plugin stuff after this line

set background=light
colorscheme solarized
call togglebg#map("<F5>")

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.opa set filetype=opa
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" OCaml
" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
function! SetupOCaml()
  nnoremap <leader>t :MerlinTypeOf<cr>
  vnoremap <leader>t :MerlinTypeOfSel<cr>
  nnoremap <leader>f :MerlinLocate<cr>
  " nnoremap <leader>d :MerlinDestruct<cr>
  nnoremap <leader>o :MerlinOccurrences<cr>
  nnoremap <leader>O :MerlinOutline<cr>
  nnoremap <leader>l :MerlinILocate<cr>
  nmap <leader>n  <Plug>(MerlinSearchOccurrencesForward)
  nmap <leader>N  <Plug>(MerlinSearchOccurrencesBackward)
  nmap <leader>r  <Plug>(MerlinRename)
  nmap <leader>R  <Plug>(MerlinRenameAppend)

  " Load topkg in Merlin when editing pkg/pkg.ml
  if expand("%:p") =~# "pkg\/pkg\.ml$"
    call merlin#Use("topkg")
  endif

  call SuperTabSetDefaultCompletionType("<c-x><c-o>")
endfunction
" somehow this can't be inside the function...
let g:merlin_textobject_grow   = 'm'
let g:merlin_textobject_shrink = 'M'
au FileType ocaml call SetupOCaml()
" ocp-indent
execute 'autocmd FileType ocaml source' g:opamshare . "/ocp-indent/vim/indent/ocaml.vim"
autocmd BufNewFile,BufRead jbuild setlocal filetype=scheme
" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = "x"
let g:syntastic_warning_symbol = "!"
let g:syntastic_style_error_symbol = "x"
let g:syntastic_style_warning_symbol = "!"
"let g:syntastic_auto_jump = 2
let g:syntastic_ocaml_checkers = ['merlin']

" http://chneukirchen.org/dotfiles/.vimrc
" a selects everything in visual selection mode
"vmap a <esc>ggVG
" background, even in insert mode
map! <C-Z> <C-O>:stop<C-M>

" http://amix.dk/vim/vimrc.html
let mapleader = ","
let g:mapleader = ","
" Fast saving
nmap <leader>s :w!<cr>
nmap <leader>q :q!<cr>

" nmap <C-X> :w!<cr>
" imap <C-X> <esc>:w!<cr>i

nmap <leader>a :Ag <cword><cr>
nmap <leader>A :AgBuffer <cword><cr>

" toggle comment with C-/
"nmap  <leader>ci
"imap  <esc><leader>ci
"vmap  <leader>ci " cs does multipart if available, but does not toggle :(

" https://github.com/nihathrael/configs/blob/master/.vimrc
set viminfo+=!          " support for yanking
set mouse=a             " enable mouse
set number              " show line numbers

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#why-i-came-back-to-vim
" FocusLost only works with gvim -> don't use relativenumber in terminal
" if has("gui-running")
"     set relativenumber
"     "http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
"     "http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
"     augroup relnum
"         autocmd!
"         autocmd FocusLost * :set norelativenumber
"         autocmd FocusGained * :set relativenumber
"         autocmd InsertEnter * :set norelativenumber
"         autocmd InsertLeave * :set relativenumber
"     augroup END
" endif
" set cpo+=J " http://stevelosh.com/blog/2012/10/why-i-two-space/

" http://choorucode.com/2014/01/24/how-to-enable-case-insensitive-filename-completion-in-vim/
set wildignorecase
set wildmode=list:longest,full
augroup AutoReloadVimRC
  au!
  au BufWritePost $MYVIMRC so $MYVIMRC " load new .vimrc on save (only adds :/)
augroup END

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
" nnoremap <tab> %
" vnoremap <tab> %

set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set 	formatoptions+=l

" don't add newline at the end of files
" set binary
" set noeol

set list
set listchars=tab:▸\ ,trail:\ 

""""""""" Show superfluos spaces """""""""
:highlight ExtraWhitespace ctermbg=darkred guibg=darkred
" :autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

""""""""" ü = :shell """""""""""""""""""""
nmap ü :shell<cr>

""""""""" buffer magic """""""""""""""""""
" <M-k> doesn't work in gnome-terminal, but typing ctrl-v alt-k works
nnoremap k :bn!<cr>
nnoremap j :bp!<cr>
nnoremap d :bd!<cr>
set hidden " allows switching to another buffer with unsaved buffer open

""""""""" ó,ö = y/p with clipboard """""""""
" vmap ó "+y
" nmap ó viwó             " Y already used in normal mode
" map ö "+gP
set clipboard=unnamed " use the system clipboard per default (must be compiled with +clipboard, if not try gvim -v)

""""""""" gp = select pasted text """"""""
nnoremap gp `[v`]

set pastetoggle=<F12>

" tab navigation
" map <C-j> :tabprevious<CR>
" map <C-k> :tabnext<CR>
" imap <C-j> <Esc>:tabprevious<CR>i
" imap <C-k> <Esc>:tabnext<CR>i
" map <C-t> :tabnew<Space>
" imap <C-t> <Esc>:tabnew<Space>

"map <M-o> O<ESC>

" keep selection on indentation
vnoremap < <gv
vnoremap > >gv

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_CompileRule_pdf = 'latexmk -pdf -shell-escape $*'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_UseMakefile = 0

" insert lines and stay in normal mode
" nmap  O<Esc>
" nmap <CR> o<Esc>
nnoremap K i<CR><Esc>

" load changed files automatically
" set autoread " only works for gui
au CursorHold,CursorHoldI * silent! checktime

" persistent undo
set undofile

" compile & run
au FileType c setlocal makeprg=clang\ %
au FileType cpp setlocal makeprg=clang\ %
" autocmd QuickfixCmdPost make call AfterMakeC()
function! AfterMakeC()
    if len(getqflist()) == 0
        !./a.out
    endif
endfunction
map <F7> :w<CR> :make<CR> :call AfterMakeC()<CR>

" no folds by default!, use zi to toggle
set nofoldenable
set foldlevel=99
" set viewoptions-=folds
" save and restore position, folds, etc.
au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview

" jump to the last position when reopening a file and center it
if has("autocmd")
  " au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " restore last position at the top
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! zz" | endif " center line somehow doesn't work :(
endif

" set cursorline
" set cursorcolumn
" autocmd WinEnter * setlocal cursorcolumn
" autocmd WinLeave * setlocal nocursorcolumn

" http://stackoverflow.com/questions/15968880/vim-cursor-position-on-new-split-window
set splitbelow
set splitright

" we'd like to keep our horizontal cursor position when duplicating lines...
nmap [d mzyyP`zk
nmap ]d mzyyp`zj

" MacVim startup is too slow...
let g:did_install_default_menus = 1
let g:did_menu_trans = 1

" nnoremap <leader>m :silent make\|redraw!\|cc<CR>
" via vim-dispatch:
autocmd FileType java let b:dispatch = 'javac %'
nnoremap <leader>d :w<cr>:Dispatch!<cr>

" this needs to be at the end since it's (re)set when compatible is (re)set
autocmd BufNewFile,BufRead * setlocal formatoptions-=o " disable comment continuation for o/O (use enter)
