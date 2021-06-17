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
Plug 'eugen0329/vim-esearch'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'posva/vim-vue'
Plug 'google/vim-jsonnet'
Plug 'yegappan/mru'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'
call plug#end()
"========================================================
" EDITOR CONFIGS
"========================================================
set clipboard=unnamedplus
set completeopt=menuone,noselect " Prerequisite for compe
set ignorecase
set laststatus=2
set lazyredraw
set linespace=1
set nobackup
set nofoldenable
set nosmd
set nowritebackup
set number
set shortmess+=c
set signcolumn=yes
set smartcase
set splitbelow
set splitright
set termguicolors
set timeoutlen=1000 ttimeoutlen=0
set ttyfast
set updatetime=300
set encoding=utf-8

if has("autocmd")
  autocmd FileType jsonnet set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType python set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType vue set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType go set tabstop=8 shiftwidth=8 softtabstop=8
  autocmd FileType c set tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufEnter * autocmd! matchparen
endif

colorscheme deep-space
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
      \             [ 'readonly', 'filename', 'modified'] ]
      \ }
      \ }
"========================================================
" CONFIG LSP
"========================================================
lua <<EOF
local nvim_lsp = require('lspconfig')
require'lspconfig'.solargraph.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.vuels.setup{}
require'lspconfig'.tsserver.setup{}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gj', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local servers = { "jedi_language_server", "rust_analyzer", "tsserver" , "gopls", "solargraph"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}
EOF
"========================================================
" CONFIG ALE
"========================================================
let g:ale_linter_aliases = {'rspec': ['ruby']}
let g:ale_linters = {
\ 'ruby': ['rubocop'],
\ 'python': ['flake8'],
\ 'rspec': ['rubocop'],
\ 'c': [''],
\ 'cpp': [''],
\}
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
\ 'rspec': ['remove_trailing_lines', 'trim_whitespace'],
\ 'c': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1
"========================================================
" CONFIG FZF
"========================================================
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Default all to a floating window
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

" Search recent files
function! FilterOldfiles(path_prefix) abort
  let path_prefix = '\V'. escape(a:path_prefix, '\')
  let counter     = 30
  let entries     = {}
  let oldfiles    = []

  for fname in MruGetFiles()
    if counter <= 0
      break
    endif

    let absolute_path = resolve(fname)
    " filter duplicates, bookmarks and entries from the skiplist
    if has_key(entries, absolute_path)
          \ || !filereadable(absolute_path)
          \ || match(absolute_path, path_prefix)
      continue
    endif
    let relative_path = fnamemodify(absolute_path, ":~:.")

    let entries[absolute_path]  = 1
    let counter                -= 1
    let oldfiles += [relative_path]
  endfor

  return oldfiles
endfunction

function! FzfRecentFiles()
  return fzf#run(fzf#wrap({
        \ 'source': FilterOldfiles(getcwd()),
        \ 'options': [
        \ '-m', '--header-lines', !empty(expand('%')),
        \ '--prompt', 'Recent files> ',
        \ "--preview", "bat {} --color=always --style=plain",
        \ '--preview-window', 'down:50%'
        \ ]}))
endfunction
noremap <silent> <c-r> <ESC>:call FzfRecentFiles()<CR>

" Search files
let g:fzf_preview_source=" --preview='bat {} --color=always --style=plain' --preview-window down:50%"
noremap <silent> <c-p> <ESC>:call fzf#vim#files('.', {'options': g:fzf_preview_source})<CR>

" A backup searcher for esearch
let g:fzf_preview_window = ['down:50%', 'ctrl-/']
noremap <leader>fr <ESC>:Rg<space>
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

  setlocal buftype=nofile
endfunction
let g:esearch.win_new = {esearch -> EsearchFloatingWindow()}
autocmd User esearch_win_config autocmd BufLeave <buffer> quit

let g:esearch.win_map = [
 \ ['n', 'x',   '<plug>(esearch-win-split:reuse:stay):q!<cr>'],
 \ ['n', 'v',   '<plug>(esearch-win-vsplit:reuse:stay):q!<cr>'],
 \ ['n', '{',   '<plug>(esearch-win-jump:filename:up)'],
 \ ['n', '}',   '<plug>(esearch-win-jump:filename:down)'],
 \ ['n', 'j',   '<plug>(esearch-win-jump:entry:down)'],
 \ ['n', 'k',   '<plug>(esearch-win-jump:entry:up)'],
 \ ['n', 'r',   '<plug>(esearch-win-reload)'],
 \ ['n', '<cr>', '<plug>(esearch-win-open)'],
 \ ['n', '<esc>', ':q!<cr>']
 \]
nmap <silent> <leader>ff <plug>(esearch)

highlight link esearchLineNr Comment
highlight link esearchCursorLineNr esearchFilename
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

" Auto pair
let g:AutoPairsMultilineClose = 0
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
let g:startify_session_number = 3
let g:startify_session_sort = 1

function! GetUniqueSessionName()
  let path = fnamemodify(getcwd(), ':~:t')
  let path = empty(path) ? 'no-project' : path
  let branch = system('git branch --no-color --show-current 2>/dev/null')
  let branch = empty(branch) ? '' : '-' . branch
  return substitute(path . branch, '/', '-', 'g')
endfunction
" Don't forget to create ~/.vim/session, or vim requires an extra enter when exit
autocmd VimLeavePre * silent execute 'SSave! ' . GetUniqueSessionName()

function! StarifyGitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

function! StarifyGitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction
let g:startify_lists = [
      \ { 'type': 'sessions',                      'header': ['   Sessions']       },
      \ { 'type': 'dir',                           'header': ['   MRU '. getcwd()] },
      \ { 'type': function('StarifyGitModified'),  'header': ['   Git modified']},
      \ { 'type': function('StarifyGitUntracked'), 'header': ['   Git untracked']},
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
