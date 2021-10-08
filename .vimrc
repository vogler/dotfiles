if 0 | endif " Note: Skip initialization for vim-tiny or vim-small.

" use vim-plug instead of neobundle, vundle, vim-pathogen
" https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim')) " automatic setup
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-sensible' " Defaults everyone can agree on
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set shortmess+=A " don't give the "ATTENTION" message when an existing swap file is found
"Plug 'tpope/vim-commentary'
"autocmd FileType ocaml set commentstring=(*\ %s\ *)
"Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
map <C-l> :NERDTreeFind<CR> " open sidebar on the left and focus current file
" let NERDTreeMinimalUI=1
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tomtom/tcomment_vim'
let g:tcomment#commentstring_c = '// %s'
Plug 'tpope/vim-fugitive' " provides :G (:Git), :GMove, :GBrowse etc.
Plug 'tpope/vim-rhubarb' " GitHub extension for fugitive.vim: :GBrowse, omni-complete issues etc. in commit messages
" Plug 'tpope/vim-endwise' " end certain structures (if, do, etc.) automatically. Disabled because it remapped <cr> which is needed to accept multi-word suggetion in coc.nvim
Plug 'tpope/vim-surround' " add/change/delete surrounding parentheses, brackets, quotes, XML tags
Plug 'tpope/vim-repeat' " make . also repeat plugin maps instead of just native commands
Plug 'tpope/vim-eunuch' " UNIX shell commands :Delete, :Move, :SudoWrite etc.
Plug 'tpope/vim-unimpaired' " Pairs of handy bracket mappings
Plug 'tpope/vim-rsi' " Readline key bindings in insert mode
" Plug 'tpope/vim-sleuth' " Heuristically set buffer options shiftwidth, expandtab
" Set manually since I prefer tab = 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent
" set cindent
Plug 'tpope/vim-obsession' " cont. updated session files; :Obsess starts recording, load with -S or :source
Plug 'tpope/vim-vinegar' " file browser enhancements (- opens netrw), - goes up one directory but keeps file focused (enter to go back)
" Plug 'tpope/vim-characterize' " Unicode character metadata (press ga on a character)
Plug 'tpope/vim-speeddating' " increment (C-A) / decrement (C-X) for date/time formats
Plug 'tpope/vim-jdaddy' " JSON text objects (aj, ij) and pretty printing (gqaj)
" Plug 'tpope/vim-markdown'
Plug 'gabrielelana/vim-markdown' " syntax highlighting for GitHub Markdown flavor
Plug 'tpope/vim-dispatch' " Asynchronous build and test dispatcher :Make
Plug 'tpope/vim-dadbod' " interface for many databases :DB postgresql:///foobar, :DB sqlite:myfile.sqlite3 select count(*) from widgets

Plug 'wellle/targets.vim' " text objects for pair, quote, separator, argument, tag
Plug 'mhinz/vim-startify' " start screen (if opened without arg) instead of empty buffer with MRU, bookmarks, sessions
Plug 'flazz/vim-colorschemes' " colorscheme pack including solarized
Plug 'altercation/vim-colors-solarized' " :colorscheme solarized (overwrites the above?)
Plug 'vim-airline/vim-airline' " status line with multiple sections and support for many plugins
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy
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
Plug 'vim-airline/vim-airline-themes' " :AirlineTheme solarized
" Plug 'bling/vim-bufferline'

Plug 'airblade/vim-gitgutter' " git diff markers in sign column; jump to next hunk with ]c, stage hunk with ,hs, undo with ,hu
set updatetime=250 " terminal vim might have highlighting glitches for low times...

Plug 'michaeljsmith/vim-indent-object' " text object for LOC at the same indent level: ii (inner indentation level), ai (incl. line above), iI, aI; e.g. vii
" Plug 'terryma/vim-multiple-cursors' " C-n to add match; TODO deprecated, use vim-visual-multi instead
Plug 'mg979/vim-visual-multi' " multiple cursors; add word with C-n, n/N next/prev, [/] select cursor, q skip, Q remove, tab to switch cursor (normal) and extend (visual) mode
" https://vi.stackexchange.com/questions/609/swap-function-arguments
" Plug 'AndrewRadev/sideways.vim' " :SidewaysLeft/Right to move item (defined by delimiter) under the cursor left/right
Plug 'machakann/vim-swap' " swap delimited items; g< left, g> right, gs interactive (h, l, j, k, 1-9, g/G group/ungroup, s sort, r reverse)
" Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align' " ga EasyAlign, vipga= (visual inner paragraph align around =), gaii2& (align around 2nd & on inner indentation level)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
Plug 'junegunn/vim-peekaboo' " shows contents of registers on the right in sidebar on \" and @ in normal mode and C-r in insert mode
Plug 'junegunn/goyo.vim', {'on': 'Goyo'} " distraction-free writing
" let g:goyo_width = '80%' " default 80 (characters)
Plug 'junegunn/limelight.vim', {'on': 'Limelight'} " only do syntax highlighting for current paragraph
let g:limelight_conceal_ctermfg = 'gray'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
Plug 'junegunn/gv.vim', {'on': 'GV'} " :GV opens git commit browser, :GV! only commits for current file, :GV? fills location list the revisions of current file, can be used in visual mode to work on jsut lines
Plug 'junegunn/rainbow_parentheses.vim', {'on': 'RainbowParentheses'} " same color for same bracket pairs
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} " :MarkdownPreview opens in browser with synchronized scrolling
Plug 'kien/ctrlp.vim' " Fuzzy file, buffer, mru, tag, etc finder
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

" IDE features (completion, linting/checking, formatting) done by coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " Nodejs extension host for vim & neovim, load extensions like VSCode and host language servers. TODO move out the below default config...
  " extensions :CocInstall coc-json coc-tsserver
    let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-explorer', 'coc-yank', 'coc-markdownlint', 'coc-sh', 'coc-word']
    " https://github.com/weirongxu/coc-explorer better than nerdtree?
    nnoremap <silent><nowait> <space>e <Cmd>CocCommand explorer --reveal-when-open<CR>
    " https://github.com/neoclide/coc-yank
    nnoremap <silent><nowait> <space>y  :<C-u>CocList -A --normal yank<cr>
    " https://github.com/neoclide/coc-lists
    " https://github.com/neoclide/coc-git

  let g:coc_disable_startup_warning = 1 " warning: coc.nvim works best on vim >= 8.1.1719 and neovim >= 0.4.0

  " from https://github.com/neoclide/coc.nvim#example-vim-configuration

  set shortmess+=c " Don't pass messages to |ins-completion-menu|.

  " Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
  if has("nvim-0.5.0") || has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
  else
    set signcolumn=yes
  endif

  " Use tab for trigger completion with characters ahead and navigate.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin!
  " Check with :verbose imap <cr>
  " Had to disable endwise.vim. https://github.com/neoclide/coc.nvim/issues/2576
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>x :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" linting / syntax checking -- replaced by coc
  " Plug 'scrooloose/syntastic'
  " let g:ale_disable_lsp = 1 " https://github.com/dense-analysis/ale#5iii-how-can-i-use-ale-and-cocnvim-together
  " Plug 'dense-analysis/ale'
  " let g:ale_sign_error = 'x'
  " let g:ale_sign_warning = '!'
  " let g:ale_linters_ignore = ['writegood', 'proselint'] " proselint
  " let g:ale_javascript_eslint_suppress_missing_config = 1
  " let g:ale_linters = {'javascript': ['prettier', 'eslint']}

" Plug 'sjl/gundo.vim'
Plug 'simnalamburt/vim-mundo' " undo tree visualizer, fork of Gundo, :MundoToggle TODO init error: A supported python version was not found.

" motion plugins
" Plug 'bkad/CamelCaseMotion'
Plug 'chaoren/vim-wordmotion' " more useful word motions incl. camel case, upper/lowercase, hex, numbers etc.
let g:wordmotion_prefix = '<Leader>'
Plug 'unblevable/quick-scope' " highlight unique character to find in each word
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
Plug 'Lokaltog/vim-easymotion' " highlights targets to jump to, e.g. ,,w forward word, ,,j down line
" map <Leader> <Plug>(easymotion-prefix) " default is <Leader><Leader> to avoid conflicts with other plugins
let g:EasyMotion_smartcase   = 1
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" https://github.com/ggandor/lightspeed.nvim not my taste
" https://github.com/phaazon/hop.nvim rewrite of EasyMotion for neovim which does not change buffer to annotate targes; but not as nice to use as EasyMotion

" deprecated: https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
" Plug 'rking/ag.vim' " try mileszs/ack.vim, mhinz/vim-grepper, jremmen/vim-ripgrep
Plug 'mileszs/ack.vim' " ag search results in quickfix window
let g:ackprg = 'ag --vimgrep --smart-case'
" let g:ackpreview = 1
" let g:agprg="ag --nogroup --nocolor --column"

command YankStatusMsg let @+ = v:statusmsg " for copying error messages
Plug 'google/vim-searchindex' " display number of search matches & index of a current match
" Plug 'junegunn/vim-slash' " Automatically clears search highlight when cursor is moved; Improved star-search (visual-mode, highlighting without moving)
" noremap <plug>(slash-after) zz " Places the current match at the center of the window

autocmd BufReadPre * if getfsize(@%) > 100000 | let b:tagbar_ignore = 1 | endif
Plug 'majutsushi/tagbar' " sidebar with outline viewer / ctags of current file
nmap <F8> :TagbarToggle<CR>
let g:tagbar_compact = 1
if !has('nvim')
  Plug 'drmikehenry/vim-fixkey' " allows vim to bind <A-j> (like nvim) instead of having to use j or <Esc>j
endif
" Plug 'thaerkh/vim-indentguides' " sets conceallevel=2, see https://github.com/thaerkh/vim-indentguides/issues/17
" set conceallevel=0
" set concealcursor=""

" Plug 'sheerun/vim-polyglot' " 144 language packs
" Plug 'Twinside/vim-hoogle' " query hoogle, the haskell search engine
Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
" Plug 'digitaltoad/vim-jade'
Plug 'leafgarland/typescript-vim' " syntax files
Plug 'Quramy/tsuquyomi' " client for TSServer: Completion, Navigate, etc.
" Plug 'jcf/vim-latex'
Plug 'idris-hackers/idris-vim', {'for': 'idris'}
Plug 'FStarLang/VimFStar', {'for': 'fstar'}
Plug 'lambdatoast/elm.vim', {'for': 'elm'}
" Plug 'let-def/vimbufsync' " Collection of heuristics to help quickly detect modifications in vim buffers
" Plug 'the-lambda-church/coquille', {'for': 'coq'}
" Plug 'https://manu@framagit.org/manu/coq-au-vim.git', {'for': 'coq'} " only works with vim, not nvim, no syntax
" Plug 'jvoorhis/coq.vim', {'for': 'coq'} " syntax
" Plug 'https://framagit.org/tyreunom/coquille.git', {'for': 'coq', 'do': ':UpdateRemotePlugins'} " fork for neovim and coq 8.9, contains syntax
" Plug 'vim-ocaml-conceal'
" Plug 'MLstate/opalang', {'rtp': 'tools/editors/vim/'} " just copy to .vim/ since this rtp option doesn't seem to work, also the repo is huge
" Plug 'typedebugger' " see http://pllab.is.ocha.ac.jp/~asai/TypeDebugger/

" Plug 'git-time-metric/gtm-vim-plugin'
  " let g:gtm_plugin_status_enabled = 1
  " function! AirlineInit()
  "   if exists('*GTMStatusline')
  "     call airline#parts#define_function('gtmstatus', 'GTMStatusline')
  "     let g:airline_section_b = airline#section#create([g:airline_section_b, ' ', '[', 'gtmstatus', ']'])
  "   endif
  " endfunction
  " autocmd User AirlineAfterInit call AirlineInit()
Plug 'wakatime/vim-wakatime' " automatic time tracking and metrics, wakatime.com
Plug 'vim-scripts/DeleteTrailingWhitespace' " :DeleteTrailingWhitespace
Plug 'lervag/vimtex', {'for': 'tex'}
" let g:tex_conceal = "" " fix for vim-indentguides' conceallevel=2
" w/o vimtex, autoindent is a bit annoying https://vi.stackexchange.com/questions/2906/how-can-i-fix-the-auto-indentation-in-latex
" Plug 'xuhdev/vim-latex-live-preview', {'for': 'tex'}
" let g:livepreview_engine = 'latexmk' . ' -pdf -shell-escape'
Plug 'chrisbra/csv.vim' " CSV editor, :CSVSort, :MoveColumn
let b:csv_arrange_align = 'l*' " :CSVArrangeColumn should left-align (default is right)
let g:csv_autocmd_arrange = 1 " ArrangeColumn for all *.csv and only UnArrangeColumn for writing
let g:csv_autocmd_arrange_size = 1024*1024 " only do it for files up to 1 MB (slow for big files)

call plug#end()


set background=dark
colorscheme solarized
highlight! link SignColumn LineNr
" call togglebg#map("<F5>") " seldomly used -> use ToggleBG instead

autocmd BufNewFile,BufReadPost *.opa set filetype=opa
autocmd BufNewFile,BufReadPost *.v set filetype=coq
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" OCaml
" merlin -- replaced by ocaml-lsp in coc
let g:opamshare = substitute(system('cd && opam var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
" function! SetupOCaml()
"   nnoremap <leader>t :MerlinTypeOf<cr>
"   vnoremap <leader>t :MerlinTypeOfSel<cr>
"   nnoremap <leader>f :MerlinLocate<cr>
"   " nnoremap <leader>d :MerlinDestruct<cr>
"   nnoremap <leader>o :MerlinOccurrences<cr>
"   nnoremap <leader>O :MerlinOutline<cr>
"   nnoremap <leader>l :MerlinILocate<cr>
"   nmap <leader>n  <Plug>(MerlinSearchOccurrencesForward)
"   nmap <leader>N  <Plug>(MerlinSearchOccurrencesBackward)
"   nmap <leader>r  <Plug>(MerlinRename)
"   nmap <leader>R  <Plug>(MerlinRenameAppend)
"
"   " Load topkg in Merlin when editing pkg/pkg.ml
"   if expand("%:p") =~# "pkg\/pkg\.ml$"
"     call merlin#Use("topkg")
"   endif
"
"   " call SuperTabSetDefaultCompletionType("<c-x><c-o>")
" endfunction
" " somehow this can't be inside the function...
" let g:merlin_textobject_grow   = 'm'
" let g:merlin_textobject_shrink = 'M'
" au FileType ocaml call SetupOCaml()
" ocp-indent
execute 'autocmd FileType ocaml source' g:opamshare . "/ocp-indent/vim/indent/ocaml.vim"
autocmd BufNewFile,BufRead dune* setlocal filetype=lisp
autocmd BufNewFile,BufRead *opam* setlocal filetype=yaml

" latex
function! SetupLatex()
  " https://tex.stackexchange.com/questions/62182/shortcut-for-inserting-matching-endsomething-in-vim
  " put \begin{} and \end{} tags around the current word
  map! <C-B> <ESC>YpI\end{<ESC>A}<ESC>kI\begin{<ESC>A}<esc>o
endfunction
au FileType tex call SetupLatex()

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
nnoremap <silent><nowait> <space>q :q!<cr>
nmap <leader>x :x!<cr> " same as ZZ (only write if changes have been made)
nmap <leader>c :Gwrite<cr>:Git commit -v --quiet<cr>
nmap <leader>C :Git commit -v --quiet<cr>
nmap <leader>p ggVGp
nmap <leader>y :%y+<cr>

" nmap <C-X> :w!<cr>
" imap <C-X> <esc>:w!<cr>i

nmap <leader>a :Ack <cword><cr>
nmap <leader>A :AckWindow <cword><cr>

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

" set wrap
set linebreak
" set nolist
" set textwidth=0
" set wrapmargin=0
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
nnoremap <A-k> :bn!<cr>
nnoremap <A-j> :bp!<cr>
nnoremap <A-d> :bd!<cr>
nnoremap <A-1> :b 1<cr>
nnoremap <A-2> :b 2<cr>
nnoremap <A-3> :b 3<cr>
nnoremap <A-4> :b 4<cr>
nnoremap <A-5> :b 5<cr>
nnoremap <A-6> :b 6<cr>
nnoremap <A-7> :b 7<cr>
nnoremap <A-8> :b 8<cr>
nnoremap <A-9> :b 9<cr>
nnoremap <A-0> :blast<cr>
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
nnoremap <C-j> i<CR><Esc>

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
au BufWinEnter *.* silent! loadview

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
