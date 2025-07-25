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

call plug#begin('~/.vim/bundle') " Start of plugins via vim-plug
" :PlugUpdate  - install or update plugins
" :PlugUpgrade - upgrade vim-plug

Plug 'tpope/vim-sensible' " Defaults everyone can agree on
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set shortmess+=A " don't give the "ATTENTION" message when an existing swap file is found
" set autochdir " https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file - originally only added to show full path in airline? not supported by vim-dirvish, may also break other plugins; pwd shows dir of file also without this
Plug 'tpope/vim-fugitive' " provides :G (:Git), :GMove, :GBrowse etc.
Plug 'tpope/vim-rhubarb' " GitHub extension for fugitive.vim: :GBrowse, omni-complete issues etc. in commit messages
Plug 'tpope/vim-endwise' " end certain structures (if, do, etc.) automatically
Plug 'tpope/vim-surround' " add/change/delete surrounding parentheses, brackets, quotes, XML tags; cs: change, ds: delete, ys: add, yss: add line, S: add visual
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
let g:netrw_silent=1 " no "Press ENTER or type commend to continue" when editing a file via scp, e.g. nvim scp://pi@rpi3/dash.log
" nvim 0.10 brings its own `gx` for opening files/links, for earlier versions netrw is needed to provide it: https://github.com/neovim/neovim/issues/23231
" Plug 'tpope/vim-vinegar' " file browser enhancements (- opens netrw), - goes up one directory but keeps file focused (enter to go back); nice default sorting, otherwise few features
" Plug 'justinmk/vim-dirvish' " nicer than vim-vinegar, 'autochdir' is not supported
" Plug 'kristijanhusak/vim-dirvish-git' " show git status in dirvish
  " let g:dirvish_git_show_ignored = 1 " puts ☒ before ignored files, but also does so for dirs that contain ignored files...
  " let g:dirvish_git_show_icons = 0 " disable icons since they misalign entries and just rely on color for git status
  " https://github.com/roginfarrer/vim-dirvish-dovish file manipulation commands for dirvish
Plug 'stevearc/oil.nvim' " nicer than dirvish: icons, sorting, can edit filesystem in buffer and shows operations on :w, splits (^s, ^h), preview (^p); just not git status.
Plug 'refractalize/oil-git-status.nvim' " git status for oil.nvim, https://github.com/stevearc/oil.nvim/issues/85
" However, oil.nvim disables netrw and thereby `gx` to open links: https://github.com/stevearc/oil.nvim/issues/182
Plug 'chrishrb/gx.nvim' " `gx` without netrw, but also supports links without protocol, vim plugins, github issues, npm deps, and web search as a fallback, shows menu if there are alternatives :)
" Plug 'tpope/vim-characterize' " Unicode character metadata (press ga on a character)
Plug 'tpope/vim-speeddating' " increment (C-A) / decrement (C-X) for date/time formats
Plug 'tpope/vim-jdaddy' " JSON text objects (aj, ij) and pretty printing (gqaj)
" Plug 'tpope/vim-markdown' # better markdown plugins below
Plug 'tpope/vim-dispatch' " Asynchronous build and test dispatcher :Make
Plug 'tpope/vim-dadbod' " interface for many databases :DB postgresql:///foobar, :DB sqlite:myfile.sqlite3 select count(*) from widgets
Plug 'tpope/vim-abolish' " variants of words, :Abolish to create multiple abbreviations to fix typos, :Subvert for substitution, Coercion: crs snake_case, crm MixedCase, crc camelCase, cru UPPER_CASE, cr- dash-case, cr. dot.case

" # Comments
"Plug 'tpope/vim-commentary'
"autocmd FileType ocaml set commentstring=(*\ %s\ *)
"Plug 'scrooloose/nerdcommenter'
Plug 'tomtom/tcomment_vim'
let g:tcomment#commentstring_c = '// %s'
noremap <C-/> :TComment<CR> " keycode changed on some zsh/prezto/vim update from <C-_>, before this was not needed since C-/ C-/ was the default of the tcomment plugin

" # sidebar/explorer
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
map <C-l> :NERDTreeFind<CR> " open sidebar on the left and focus current file
" let NERDTreeMinimalUI=1
Plug 'Xuyuanp/nerdtree-git-plugin'
" Explorer alternatives: https://github.com/nvim-tree/nvim-tree.lua https://github.com/nvim-neo-tree/neo-tree.nvim
autocmd BufReadPre * if getfsize(@%) > 100000 | let b:tagbar_ignore = 1 | endif
Plug 'majutsushi/tagbar' " sidebar with outline viewer / ctags of current file
nmap <F8> :TagbarToggle<CR>
let g:tagbar_compact = 1

" # fuzzy finder
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file, buffer, mru, tag, etc finder
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " :Commits :BCommits :Ag :Lines :Blines :Files :GFiles :Buffers :Marks :Commands :Maps :Helptags :Filetypes :Colors
Plug 'nvim-lua/plenary.nvim' " needed for telescope
Plug 'nvim-telescope/telescope.nvim' ", { 'tag': '0.1.5' } " finder with preview, :Telescope find_files, live_grep, buffers, git_commits, keymaps, lsp_*

" # text search across files, grep/ack
" deprecated: https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
" Plug 'rking/ag.vim' " try mileszs/ack.vim, mhinz/vim-grepper, jremmen/vim-ripgrep
Plug 'mileszs/ack.vim' " ag search results in quickfix window
let g:ackprg = 'ag --vimgrep --smart-case'
" let g:ackpreview = 1
" let g:agprg="ag --nogroup --nocolor --column"

" # yank, registers
command! YankStatusMsg let @+ = v:statusmsg " for copying error messages
Plug 'ojroques/vim-oscyank' " SSH: also copy to client clipboard; alternative: https://github.com/jabirali/vim-tmux-yank
  autocmd TextYankPost * if $SSH_CLIENT != '' && v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif

" # start screen and session
Plug 'mhinz/vim-startify' " start screen (if opened without arg) instead of empty buffer with MRU, bookmarks, sessions
Plug 'rmagatti/auto-session' " `nvim` will save & restore last session (buffers etc.) for `cwd`

" # UI search in buffer
Plug 'google/vim-searchindex' " display number of search matches & index of a current match
" Plug 'junegunn/vim-slash' " Automatically clears search highlight when cursor is moved; Improved star-search (visual-mode, highlighting without moving)
" noremap <plug>(slash-after) zz " Places the current match at the center of the window

" # UI themes, font
Plug 'flazz/vim-colorschemes' " colorscheme pack including solarized8_dark
" Plug 'altercation/vim-colors-solarized' " :colorscheme solarized (overwrites the above?)
" colorscheme must be set below after plugins are loaded
set guifont=MesloLGS\ NF:h18 " Nerd Font downloaded by Powerlevel10k zsh prompt. Also set in iterm.
set termguicolors " needed for solarized8_dark
set background=dark

" # UI extensions
" Plug 'sjl/gundo.vim'
Plug 'simnalamburt/vim-mundo' " undo tree visualizer, fork of Gundo, :MundoToggle TODO init error: A supported python version was not found.
Plug 'junegunn/vim-peekaboo' " shows contents of registers on the right in sidebar on \" and @ in normal mode and C-r in insert mode
Plug 'junegunn/goyo.vim', {'on': 'Goyo'} " distraction-free writing
" let g:goyo_width = '80%' " default 80 (characters)
Plug 'junegunn/limelight.vim', {'on': 'Limelight'} " only do syntax highlighting for current paragraph
let g:limelight_conceal_ctermfg = 'gray'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
Plug 'junegunn/rainbow_parentheses.vim', {'on': 'RainbowParentheses'} " same color for same bracket pairs
Plug 'junegunn/gv.vim', {'on': 'GV'} " :GV opens git commit browser, :GV! only commits for current file, :GV? fills location list the revisions of current file, can be used in visual mode to work on jsut lines
" ## statusline
Plug 'vim-airline/vim-airline' " status line with multiple sections and support for many plugins -> replaced by faster lualine.nvim
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 0 " buffers/tabs -> replaced by bufferline.nvim
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
  function! CustomBranchName(name)
    if a:name == 'master' | return 'm ' | else | return a:name | endif
  endfunction
  let g:airline#extensions#branch#format = 'CustomBranchName'
  let g:airline_section_c = '%F' " show full path instead of just file in statusline; was not needed with autochdir
Plug 'vim-airline/vim-airline-themes' " :AirlineTheme solarized
" Plug 'nvim-lualine/lualine.nvim'
" Plug 'bling/vim-bufferline' " to save space: show list of buffers in the command bar or statusline
" ## bufferline
Plug 'akinsho/bufferline.nvim', { 'tag': '*' } " fancy buffer line with numbers for tabs on the right, close buttons, hover, colored file type icons, diagnostics etc.
" alternative: https://github.com/romgrk/barbar.nvim
  " more via https://nix-community.github.io/nixvim/plugins/barbecue/index.html
" alternative: https://github.com/utilyre/barbecue.nvim
Plug 'tiagovla/scope.nvim' " scope buffers to tab
nnoremap <space><tab> :tabnew<cr>
nnoremap <tab> :tabnext<cr>
nnoremap <s-tab> :tabprevious<cr>
Plug 'ryanoasis/vim-devicons' " adds file type icons to NERDTree, vim-airline, CtrlP, unite, Denite, lightline, vim-startify and many more. Has to be loaded after those plugins!
Plug 'nvim-tree/nvim-web-devicons' " Colored file type icons for bufferline.nvim
Plug 'airblade/vim-gitgutter' " git diff markers in sign column; jump to next hunk with ]c, stage hunk with ,hs, undo with ,hu
  set updatetime=250 " terminal vim might have highlighting glitches for low times...
Plug 'sindrets/diffview.nvim' " show tab to cycle through all diffs with :DiffviewOpen [git rev] [options] [ -- {paths...}]
Plug 'wellle/context.vim' " show context (function, branch, indent, json path...) above buffer; alternative: https://github.com/nvim-treesitter/nvim-treesitter-context
" Plug 'wfxr/minimap.vim' " fast minimap/scrollbar - not that useful, only dots, no git signs; but good as a scrollbar (e.g. width = 2)
  " let g:minimap_width = 10
  " let g:minimap_auto_start = 1
  " let g:minimap_auto_start_win_enter = 1

" smooth scrolling
" Plug 'karb94/neoscroll.nvim' " a bit smoother than vim-smoothie...
" Plug 'psliwka/vim-smoothie'

" # motion
" Plug 'bkad/CamelCaseMotion'
Plug 'chaoren/vim-wordmotion' " more useful word motions incl. camel case, upper/lowercase, hex, numbers etc.
  let g:wordmotion_prefix = ',' " e.g. ,w instead of w
Plug 'unblevable/quick-scope' " highlight unique character to find in each word
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" used easymotion for a long time, checked alternatives and now trying leap
" Plug 'Lokaltog/vim-easymotion' " highlights targets to jump to, e.g. ,,w forward word, ,,j down line
  " map <Leader> <Plug>(easymotion-prefix) " default is <Leader><Leader> to avoid conflicts with other plugins
  " let g:EasyMotion_smartcase   = 1
  " let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" https://github.com/phaazon/hop.nvim rewrite of EasyMotion for neovim which does not change buffer to annotate targets; but not as nice to use as EasyMotion
" https://github.com/justinmk/vim-sneak s{char}{char} for search/motion across multiple lines (repeat ;/,)
  " let g:sneak#label = 1 " label-mode for a minimalist alternative to EasyMotion
" https://github.com/ggandor/lightspeed.nvim not my taste, superseded by leap
" https://github.com/ggandor/leap.nvim better vim-sneak, successor of lightspeed
Plug 'ggandor/leap.nvim' " example: go to text ab, where xy are labels: sabx with leap and ,,wxy with easymotion
  " alternatives: s = cl or xi, S = cc
  map s <Plug>(leap-forward-to)
  map S <Plug>(leap-backward-to)
  map gh <Plug>(leap-from-window)
  " default is gs which is already used by vim-swap; gh starts Select-mode (like Visual-mode but replaces text) which we don't need
" https://github.com/folke/flash.nvim adds jump labels to regular search results, also supports ftFT motions, standalone jump, multi window jump, remote actions and treesitter; TODO easier to configure with lua
" Plug 'folke/flash.nvim'

" # text objects
Plug 'wellle/targets.vim' " text objects for pair, quote, separator, argument, tag
Plug 'michaeljsmith/vim-indent-object' " text object for LOC at the same indent level: ii (inner indentation level), ai (incl. line above), aI (incl. line above/below); e.g. vii

" # text edits
Plug 'vim-scripts/DeleteTrailingWhitespace' " :DeleteTrailingWhitespace
Plug 'matze/vim-move' " A-k/A-j move line/selection up/down; A-h/A-l move char/selection left/right
" https://vi.stackexchange.com/questions/609/swap-function-arguments
" Plug 'AndrewRadev/sideways.vim' " :SidewaysLeft/Right to move item (defined by delimiter) under the cursor left/right
Plug 'machakann/vim-swap' " swap delimited items; g< left, g> right, gs interactive (h, l, j, k, 1-9, g/G group/ungroup, s sort, r reverse)
" Plug 'LunarWatcher/auto-pairs' " maintained fork of jiangmiao/auto-pairs; insert/delete brackets/parens/quotes in pairs
" Plug 'vim-scripts/auto-pairs-gentle' " auto-pairs had problems deleting pairs in .js files, this works. Also disabled since it inserted internal code on enter in lua code.
" Plug 'echasnovski/mini.pairs' " This finally seems to work without problems (but needs lua require... below) - also annoying when adding quotes (^ is the cursor): ^foo -> '^'foo -> ''^foo -> '^foo
Plug 'windwp/nvim-autopairs' " this gets the above right, just have to hit ctrl-d when adding vim comments at the end of a line

" # multiple cursors
" Plug 'terryma/vim-multiple-cursors' " C-n to add match; TODO deprecated, use vim-visual-multi instead
Plug 'mg979/vim-visual-multi' " multiple cursors; add word with C-n, n/N next/prev, [/] select cursor, q skip, Q remove, tab to switch cursor (normal) and extend (visual) mode

" # visual guides
" Plug 'thaerkh/vim-indentguides' " sets conceallevel=2, see https://github.com/thaerkh/vim-indentguides/issues/17
" set conceallevel=0
" set concealcursor=""

" # fixes for vim if neovim not available
if !has('nvim')
  Plug 'drmikehenry/vim-fixkey' " allows vim to bind <A-j> (like nvim) instead of having to use j or <Esc>j
endif

" # time tracking
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

" # align
" Plug 'godlygeek/tabular' " text filtering and alignment
Plug 'junegunn/vim-easy-align' " ga EasyAlign, vipga= (visual inner paragraph align around =), gaii2& (align around 2nd & on inner indentation level)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" # CSV
Plug 'chrisbra/csv.vim' " CSV editor, :CSVSort, :MoveColumn
let b:csv_arrange_align = 'l*' " :CSVArrangeColumn should left-align (default is right)
let g:csv_autocmd_arrange = 1 " ArrangeColumn for all *.csv and only UnArrangeColumn for writing
let g:csv_autocmd_arrange_size = 1024*1024 " only do it for files up to 1 MB (slow for big files)

" # Markdown
" Plug 'gabrielelana/vim-markdown' " syntax highlighting for GitHub Markdown flavor; started throwing error for some time; last updated 03/2020
" Plug 'preservim/vim-markdown' " syntax highlighting but not as nice as the above, folding, concealing; requires tabular for some features; bad auto-indent for lists: https://github.com/preservim/vim-markdown/issues/126
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_auto_insert_bullets = 0 " disable since it wasn't working right anyway
" default in vim: use <C-t> to increase and <C-d> to decrease indent level in insert mode
let g:markdown_recommended_style = 0 " otherwise ftplugin/markdown.vim (comes with neovim) resets shiftwidth=4, found out via :verbose set shiftwidth?; also see :help ft-markdown-plugin; however, this also disables list continuation on enter
Plug 'bullets-vim/bullets.vim' " enable list continuation on enter or o for - or * in [markdown, text, gitcommit, scratch]; behaves as it should and also ends lists on enter*2; new line without list with <C-Enter>; renumber in visual with gN; ,x to toggle checklist
" no multilevel numbered lists yet: https://github.com/bullets-vim/bullets.vim/issues/136
let g:bullets_outline_levels = ['num', 'abc', 'std-'] " override default levels, otherwise - continues nesting with * and +
" Plug 'SidOfc/mkdx' " functions for lists, checkboxes, code, shortcuts, headers, links; remaps/breaks `gx` for opening links in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} " :MarkdownPreview opens in browser with synchronized scrolling - at some point did not open anything anymore, using `yarn install` instead of the above fixed it - https://github.com/iamcco/markdown-preview.nvim/issues/188
" alternative markdown preview: https://github.com/toppair/peek.nvim
let g:mkdp_auto_close = 0 " default 1: nvim will auto close current preview window when changing from Markdown buffer to another buffer
" Plug 'lukas-reineke/headlines.nvim' " adds horizontal highlights for text filetypes, like markdown, orgmode, and neorg

" # LaTeX - using vscode with https://github.com/James-Yu/LaTeX-Workshop
Plug 'lervag/vimtex', {'for': 'tex'}
" let g:tex_conceal = "" " fix for vim-indentguides' conceallevel=2
" w/o vimtex, autoindent is a bit annoying https://vi.stackexchange.com/questions/2906/how-can-i-fix-the-auto-indentation-in-latex
" Plug 'xuhdev/vim-latex-live-preview', {'for': 'tex'}
" let g:livepreview_engine = 'latexmk' . ' -pdf -shell-escape'

" # other languages: syntax highlighting etc.
" Plug 'sheerun/vim-polyglot' " 144 language packs
" Plug 'Twinside/vim-hoogle' " query hoogle, the haskell search engine
Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
" Plug 'digitaltoad/vim-jade'
" Plug 'leafgarland/typescript-vim' " syntax highlighting for old TypeScript, now included in vim
" Plug 'Quramy/tsuquyomi' " client for TSServer: Completion, Navigate, etc.
" Plug 'leafOfTree/vim-svelte-plugin' " syntax-highlighting for ts did not work
Plug 'evanleck/vim-svelte', {'branch': 'main'} 
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

Plug 'github/copilot.vim' " inline code suggestion via GitHub Copilot, needs subscription, `:Copilot setup`, then acccept with tab (overrides coc.nvim accept, can go through its completion menu with C-n/C-p), suggestions are more distracting than helpful most of the time, `:Copilot disable`

" Rethinking Neovim as a Tool For Writers - https://www.youtube.com/watch?v=oLpGahrsSGQ
" https://github.com/folke/twilight.nvim
" https://github.com/folke/zen-mode.nvim
" https://github.com/preservim/vim-pencil#see-also
  " https://github.com/preservim/vim-litecorrect
  " https://github.com/preservim/vim-lexical
  " https://github.com/preservim/vim-wordy
  " https://github.com/dbmrq/vim-ditto
  " https://github.com/rhysd/vim-grammarous
  " https://github.com/tpope/vim-abolish

" linting / syntax checking -- replaced by coc below
  " Plug 'scrooloose/syntastic'
  " let g:ale_disable_lsp = 1 " https://github.com/dense-analysis/ale#5iii-how-can-i-use-ale-and-cocnvim-together
  " Plug 'dense-analysis/ale'
  " let g:ale_sign_error = 'x'
  " let g:ale_sign_warning = '!'
  " let g:ale_linters_ignore = ['writegood', 'proselint'] " proselint
  " let g:ale_javascript_eslint_suppress_missing_config = 1
  " let g:ale_linters = {'javascript': ['prettier', 'eslint']}

" # IDE features (completion, linting/checking, formatting) done by coc
" alternatives: https://github.com/hrsh7th/nvim-cmp https://github.com/ms-jpq/coq_nvim
" below are the adjusted defaults until end of plugins section
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " Nodejs extension host for vim & neovim, load extensions like VSCode and host language servers. TODO move out the below default config...
  " extensions :CocInstall coc-json coc-tsserver
    " 'coc-snippets' is needed for the <TAB> code below to not fail on snippets-expand-jump
    let g:coc_global_extensions = ['coc-snippets', 'coc-json', 'coc-tsserver', 'coc-eslint', 'coc-explorer', 'coc-yank', 'coc-sh', 'coc-word', 'coc-clangd', 'coc-pyright', 'coc-go', 'coc-solargraph'] " 'coc-markdownlint', solargraph (ruby) requires `sudo gem install solargraph`
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

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " Insert <tab> when previous text is space, refresh completion if not.
  " Use <tab> and <S-tab> to navigate completion list:
  " inoremap <silent><expr> <TAB>
  "   \ coc#pum#visible() ? coc#pum#next(1):
  "   \ <SID>check_back_space() ? "\<Tab>" :
  "   \ coc#refresh()
  " inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  " Map <tab> for trigger completion, completion confirm, snippet expand and jump like VSCode:
  inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ?
    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
  let g:coc_snippet_next = '<tab>'

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " <tab> only completes the first word.
  " Make <cr> confirm the whole entry. Default binding for confirm is <C-y>.
  " :verbose imap <cr> showed that endwise.vim already remapped <cr> which broke coc's config.
  " Fix below is a mix of https://github.com/neoclide/coc.nvim/issues/262#issuecomment-792331399 and https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-cr-to-confirm-completion
  let g:endwise_no_mappings = v:true
  inoremap <expr> <Plug>CustomCocCR complete_info(['selected'])['selected'] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
  imap <CR> <Plug>CustomCocCR<Plug>DiscretionaryEnd

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


call plug#end() " Automatically executes `filetype plugin indent on` and `syntax enable`.

" signcolumn 2 instead of 0 needed for oil-git-status (index, working tree)
lua require("oil").setup({ win_options = { signcolumn = "yes:2", } })
" nmap - :Oil --float<CR> " can :q floating window, but preview does not work; also had grey background
nmap - :Oil<CR>
lua require("oil-git-status").setup()

lua require('gx').setup()
map gx :Browse<CR>

lua require('auto-session').setup {}

" adds jump labels to regular search results
" lua require('flash').setup()
" insert/delete pairs of brackets/quotes
" lua require('mini.pairs').setup()
lua require('nvim-autopairs').setup {}

" if hostname =~ 'MacBook'
if !(hostname() =~ '^rpi') " smooth scrolling is too slow on RPis via SSH
  " lua require('neoscroll').setup()
endif

" https://neovim.io/doc/user/lua-guide.html
" sadly, :lua-heredoc messes up syntax-highlighting for everything after it...
" lua << EOF
" require('lualine').setup {
"   options = { theme = 'gruvbox' },
"   sections = {
"     lualine_a = { { 'mode', fmt = function(str) return str:sub(1,1) end } }, -- only show first char of vim mode
"     lualine_c = { { 'filename', path = 3, } } -- absolute path with tilde as home; default is 0: just the filename
"   }
" }
" EOF

lua require('nvim-web-devicons').setup {}
lua require('bufferline').setup { options = { buffer_close_icon = '', diagnostics = 'coc' } }
nnoremap <space>b :BufferLinePick<cr>

lua require('scope').setup {}

" color theme can only be set after plugins are loaded
colorscheme solarized8_dark
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
let mapleader = " "
let g:mapleader = " "

" Fast saving
nmap <leader>s :w!<cr>
nmap <leader>q :q!<cr>
" same as in AstroNvim
nmap <leader>w :w!<cr>
map <C-q> :q!<cr>
" we want a keybinding to save that works in any mode, so that we can use it for bind-key in tmux
" need some mapping I don't use in insert & normal mode: sometimes use C-W in insert mode to delete word backwards; C-X to decrease numbers in normal mode.
" briefly shows error with coc
imap <C-S> <esc>:w!<cr>a
" this overwrites coc-range-select mapped above
map <C-S> :w!<cr>

nnoremap <silent><nowait> <space>q :q!<cr>
" same as ZZ (only write if changes have been made)
nmap <leader>x :x!<cr>
" just commit what is already staged
nmap <leader>c :Git commit -v --quiet<cr>
" stage file and commit
nmap <leader>C :Gwrite<cr>:Git commit -v --quiet<cr>
" automatically go into insert mode for commit messages; FugitiveEditor didn't work, but gitcommit is more general anyway
au FileType gitcommit startinsert!
nmap <leader>P :Git push<cr><cr>
" yank whole buffer
nmap <leader>y :%y+<cr>
" replace whole buffer by paste
nmap <leader>p ggVGp
:nnoremap <F5> :put =strftime('%F %T')<cr>A 
:inoremap <F5> <esc>:put =strftime('%F %T')<cr>A 

nmap <leader>a :Ack <cword><cr>
nmap <leader>A :AckWindow <cword><cr>

" delete without changing register contents (_ = black hole)
nmap <leader>d "_D
" TODO makes more sense to have a paste-replace that can be repeated like C-V: https://github.com/vim-scripts/ReplaceWithRegister
" like <leader>dp, but replaced text in register - often use Y to yank until EOL, but then the dual for pasting is an awkward v$hp
nmap <leader>v v$hp

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
  " reload .vimrc on save - however, this still does not behave the same as reopening
  " vim since it executes in the current config instead of clearing the state first.
  au! BufWritePost $MYVIMRC,.vimrc source % | redraw | echom "Reloaded " . $MYVIMRC
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

" line wrapping, no line breaking
set wrap " already set by some plugin?
set linebreak " wrap lines at `breakat` (default whitespace) instead of just cutting of inside a word 
set breakindent " wrapped lines will continue at the same indentation level
let &showbreak = '↪ ' " '⮑  ', prefix for wrapped lines
" set wrapmargin=0
set textwidth=0 " don't break lines on insert after e.g. 78 characters
set formatoptions+=l " jtcrql

" don't add newline at the end of files
" set binary
" set noeol

set list " show tabs, trailing spaces etc.
set listchars=tab:▸\ ,trail:\ 

""""""""" Show superfluos spaces """""""""
:highlight ExtraWhitespace ctermbg=darkred guibg=darkred
" :autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

""""""""" ü = :shell """""""""""""""""""""
nmap ü :shell<cr>

""""""""" buffer magic """""""""""""""""""
" <M-k> doesn't work in gnome-terminal, but typing ctrl-v alt-k works
nnoremap <C-k> :bn!<cr>
nnoremap <C-j> :bp!<cr>
nnoremap <A-d> :bd!<cr>
" nnoremap <A-1> :b 1<cr>
" nnoremap <A-2> :b 2<cr>
" nnoremap <A-3> :b 3<cr>
" nnoremap <A-4> :b 4<cr>
" nnoremap <A-5> :b 5<cr>
" nnoremap <A-6> :b 6<cr>
" nnoremap <A-7> :b 7<cr>
" nnoremap <A-8> :b 8<cr>
" nnoremap <A-9> :b 9<cr>
" nnoremap <A-0> :blast<cr>
set hidden " allows switching to another buffer with unsaved buffer open

""""""""" ó,ö = y/p with clipboard """""""""
" vmap ó "+y
" nmap ó viwó             " Y already used in normal mode
" map ö "+gP
set clipboard=unnamed " use the system clipboard per default (must be compiled with +clipboard, if not try gvim -v)

""""""""" gp = select last changed/pasted text """"""""
nnoremap gp `[v`]
" use gv to select the last visually-selected text

" set pastetoggle=<F12> " removed since handled automatically in nvim: https://neovim.io/doc/user/vim_diff.html#'pastetoggle'

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
nnoremap <A-i> i<CR><Esc>

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

set cursorline
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
nnoremap <leader>m :w<cr>:Dispatch!<cr>

" this needs to be at the end since it's (re)set when compatible is (re)set
autocmd BufNewFile,BufRead * setlocal formatoptions-=o " disable comment continuation for o/O (use enter)
