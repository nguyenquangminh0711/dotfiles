"========================================================
" INSTALL PLUGINS
"========================================================
filetype off
call plug#begin('~/.vim/plugged')
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tomtom/tcomment_vim'
Plug 'mg979/vim-visual-multi'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'mbbill/undotree'
Plug 'janko-m/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/git-time-lapse'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'sheerun/vim-polyglot'
Plug 'google/vim-jsonnet'
Plug  'eugen0329/vim-esearch'
call plug#end()
"========================================================
" EDITOR CONFIGS
"========================================================
syntax on
filetype on
filetype indent on
filetype plugin on
set ai
set autoindent
set background=dark
set breakindent
set bs=2 tabstop=2 shiftwidth=2 softtabstop=2
set clipboard=unnamedplus
set cmdheight=2
set encoding=utf8
set expandtab
set gfn=DejaVu\ Sans\ Mono\ for\ Powerline:h13
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11
set hidden
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set linespace=1
set nobackup
set nofoldenable
set nosmd
set nowritebackup
set number
set ruler
set ruler
set shortmess+=c
set signcolumn=yes
set smartcase
set splitbelow
set splitright
set termguicolors
set ttyfast
set updatetime=300

colorscheme deep-space

" Fix iterm display
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"========================================================
" CONFIG PYTHON
"========================================================
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
"========================================================
" CONFIG LIGHTLINE
"========================================================
let g:lightline = {
      \ 'colorscheme': 'deepspace',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'cocstatus'] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'CocStatus',
      \ },
      \ }
"========================================================
" CONFIG COC.nvim
"========================================================
function! CallCocAction()
  let l:action = input("Enter action: ")
  call CocAction(l:action)
endfunction

function! ShowCocDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! CocStatus() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, '⛔️ '. info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, '🚸 '. info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

nnoremap <silent> ga :call CallCocAction()<CR>
nnoremap <silent> gj :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gJv :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gJV :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gJs :call CocAction('jumpDefinition', 'split')<CR>
nnoremap <silent> gJS :call CocAction('jumpDefinition', 'split')<CR>
nnoremap <silent> gd :call ShowCocDocumentation()<CR>
nnoremap <silent> gr :call CocAction('jumpReferences')<CR>
nnoremap <silent> gl :CocList outline<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
autocmd BufWritePre *.go :call CocAction('format')

" Custom highlights
highlight CocErrorLine guibg=#444444
highlight CocWarningLine guibg=#444444
highlight CocHighlightText guibg=#444444

" Coc snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
"========================================================
" CONFIG ALE
"========================================================
let g:ale_linter_aliases = {'rspec': ['ruby']}
let g:ale_linters = {
\ 'ruby': ['rubocop'],
\ 'rspec': ['rubocop'],
\ 'c': [''],
\ 'cpp': [''],
\}
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'ruby': ['remove_trailing_lines', 'trim_whitespace'],
\ 'rspec': ['remove_trailing_lines', 'trim_whitespace'],
\ 'c': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
"========================================================
" CONFIG FZF
"========================================================
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules'
let g:fzf_preview_source=" --preview='bat {} --color=always --style=plain'"
noremap <silent> <c-p> <ESC>:call fzf#vim#files('.', {'options': g:fzf_preview_source})<CR>
noremap <c-]> <ESC>:call fzf#vim#tags(expand("<cword>"), {'options': '--exact '})<cr>
"Open FZF in floating window
let g:fzf_layout = { 'window': 'call FzfFloatingWindow()' }
function! FzfFloatingWindow()
  let height = float2nr((&lines - 2) * 0.9) " lightline + status
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.9)
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  let buf = nvim_create_buf(v:false, v:true)
  let win = nvim_open_win(buf, v:true, opts)

  "Set Floating Window Highlighting
  call setwinvar(win, '&winhl', 'Normal:Pmenu')

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction
"========================================================
" CONFIG VIM ESEARCH
"========================================================
let g:esearch = {}
let g:esearch.default_mappings = 0
let g:esearch.name = '[esearch]'
let g:esearch.regex   = 1
let g:esearch.textobj = 0
let g:esearch.case    = 'smart'

function! EsearchFloatingWindow()
  let height = float2nr((&lines - 2) * 0.9) " lightline + status
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.9)
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  let buf = nvim_create_buf(v:false, v:true)
  let win = nvim_open_win(buf, v:true, opts)
endfunction
let g:esearch.win_new = {esearch -> EsearchFloatingWindow()}
autocmd User esearch_win_config autocmd BufLeave <buffer> quit

let g:esearch.win_map = [
 \ ['n', 'x',   '<plug>(esearch-win-split:reuse:stay):q<cr>'],
 \ ['n', 'v',   '<plug>(esearch-win-vsplit:reuse:stay):q<cr>'],
 \ ['n', '{',   '<plug>(esearch-win-jump:filename:up)'],
 \ ['n', '}',   '<plug>(esearch-win-jump:filename:down)'],
 \ ['n', 'J',   '<plug>(esearch-win-jump:entry:down)'],
 \ ['n', 'K',   '<plug>(esearch-win-jump:entry:up)'],
 \ ['n', 'r',   '<plug>(esearch-win-reload)'],
 \ ['n', '<cr>', '<plug>(esearch-win-open)']
 \]
nmap <silent> <leader>ff <plug>(esearch)
"========================================================
" CONFIG NERDTree
"========================================================
noremap <silent> <leader>nt <ESC>:NERDTreeToggle<CR>
noremap <silent> <leader>rev <ESC>:NERDTreeFind<CR>
let NERDTreeMapOpenSplit = 'x'
let NERDTreeMapOpenVSplit = 'v'
"========================================================
" CONFIG RSPEC
"========================================================
noremap <Leader>tt :TestFile<CR>
noremap <Leader>ts :TestNearest<CR>
noremap <Leader>tl :TestLast<CR>
noremap <Leader>ta :TestSuite<CR>
let g:VimuxUseNearest = 0
let g:test#strategy = 'vimux'
let test#ruby#rspec#executable = 'bundle exec rspec'
"========================================================
" CONFIG EASYALIGN
"========================================================
xmap a <Plug>(EasyAlign)
nmap a <Plug>(EasyAlign)
"========================================================
" CONFIG GIT
"========================================================
nnoremap <silent> <leader>gt :call TimeLapse() <cr>
"========================================================
" CONFIG BOOKMARKS
"========================================================
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_highlight_lines = 1

function! BookmarkFzfItem(line)
  let lnr = split(v:val, ":")
  return lnr[0].":".lnr[1].""."\t".join(lnr[2:], ":")
endfunction

function! BookmarkFzfSink(line)
  let filename = split(a:line, '\t')[0]
  let file = split(filename, ':')[0]
  let line = split(filename, ':')[1]
  execute "edit "."+".line." ".file
endfunction

function! BookmarkFzf()
    call fzf#run({'source': map(bm#location_list(), 'BookmarkFzfItem(v:val)'), 'down': '30%', 'options': '--prompt "Bookmarks  >>>  "', 'sink': function('BookmarkFzfSink')})
endfunction

function! BookmarksStartifyItem(line)
  let lnr = split(v:val, ":")
  let filename = split(a:line, '\t')[0]
  let file = split(filename, ':')[0]
  let line = split(filename, ':')[1]
  return {'line': lnr[0].":".lnr[1].""."\t".join(lnr[2:], ":"), 'cmd': "edit "."+".line." ".file}
endfunction

function! BookmarksStartifyList()
  if len(bm#location_list()) == 0
    call BookmarkLoad(g:bookmark_auto_save_file, 1, 0)
  endif
  return map(bm#location_list(), 'BookmarksStartifyItem(v:val)')
endfunction
" Finds the Git super-project directory.
function! g:BMWorkDirFileLocation()
    let filename = 'bookmarks'
    let location = ''
    if isdirectory('.git')
        " Current work dir is git's work tree
        let location = getcwd().'/.git'
    else
        " Look upwards (at parents) for a directory named '.git'
        let location = finddir('.git', '.;')
    endif
    if len(location) > 0
        return location.'/'.filename
    else
        return getcwd().'/.'.filename
    endif
endfunction

nmap <leader>mm :BookmarkToggle<CR>
nmap <leader>mi :BookmarkAnnotate<CR>
nmap <leader>mn :BookmarkNext<CR>
nmap <leader>mp :BookmarkPrev<CR>
nmap <silent> <leader>ma <ESC>:call BookmarkFzf()<CR>
nmap <leader>mc :BookmarkClear<CR>
nmap <leader>mx :BookmarkClearAll<CR>
nmap <leader>mkk :BookmarkMoveUp
nmap <leader>mjj :BookmarkMoveDown
"========================================================
" CONFIG MISC
"========================================================
nnoremap <silent> <CR> <ESC>:noh<CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" Tmux navigation
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> <ESC>:TmuxNavigateLeft<CR>
nnoremap <silent> <C-l> <ESC>:TmuxNavigateRight<CR>
nnoremap <silent> <C-k> <ESC>:TmuxNavigateUp<CR>
nnoremap <silent> <C-j> <ESC>:TmuxNavigateDown<CR>
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

" Copy file path
nmap <silent> <leader>path :let @+ = expand("%")<cr>

" Vim surround
nnoremap <silent> <leader>' cs'"
nnoremap <silent> <leader>" cs"'

" Auto pair
let g:AutoPairsMultilineClose = 0
set timeoutlen=1000 ttimeoutlen=0
if has("autocmd")
  autocmd FileType go set tabstop=8 shiftwidth=8 softtabstop=8
  autocmd FileType c set tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType xml set equalprg=xmllint\ --format\ -
  autocmd BufEnter * autocmd! matchparen
endif

let vim_markdown_preview_github=1
let g:move_key_modifier = 'C'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.html.eex,*.html.erb"
let g:jsx_ext_required = 0
"========================================================
" CONFIG SIGNIFY
"========================================================
let g:signify_vcs_list = ['git']
let g:signify_sign_show_count = 0
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '-'
let g:signify_sign_change            = '·'
let g:signify_sign_changedelete      = g:signify_sign_change
highlight SignifySignAdd guibg=255
highlight SignifySignDelete guibg=255
highlight SignifySignChange guibg=255
"========================================================
" CONFIG STARTIFY
"========================================================
let g:startify_change_to_dir = 0
let g:startify_session_dir = '~/.vim/session'
let g:startify_session_persistence = 1
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': function('BookmarksStartifyList'), 'header': ['   Bookmarks'] }
      \ ]
let g:startify_custom_header = [
      \'   _________            .___               .__            __                          .__',
      \'   \_   ___ \  ____   __| _/____   __  _  _|  |__ _____ _/  |_   ___.__. ____  __ __  |  |   _______  __ ____',
      \'   /    \  \/ /  _ \ / __ |/ __ \  \ \/ \/ /  |  \\__  \\   __\ <   |  |/  _ \|  |  \ |  |  /  _ \  \/ // __ \',
      \'   \     \___(  <_> ) /_/ \  ___/   \     /|   Y  \/ __ \|  |    \___  (  <_> )  |  / |  |_(  <_> )   /\  ___/',
      \'   \______  /\____/\____ |\___  >   \/\_/ |___|  (____  /__|    / ____|\____/|____/  |____/\____/ \_/  \___  > /\',
      \'          \/            \/    \/               \/     \/        \/                                         \/  \/',
      \'   .____                                .__            __                                           .___',
      \'   |    |    _______  __ ____   __  _  _|  |__ _____ _/  |_   ___.__. ____  __ __    ____  ____   __| _/____',
      \'   |    |   /  _ \  \/ // __ \  \ \/ \/ /  |  \\__  \\   __\ <   |  |/  _ \|  |  \ _/ ___\/  _ \ / __ |/ __ \',
      \'   |    |__(  <_> )   /\  ___/   \     /|   Y  \/ __ \|  |    \___  (  <_> )  |  / \  \__(  <_> ) /_/ \  ___/',
      \'   |_______ \____/ \_/  \___  >   \/\_/ |___|  (____  /__|    / ____|\____/|____/   \___  >____/\____ |\___  > /\',
      \'           \/               \/               \/     \/        \/                        \/           \/    \/  \/',
      \]
