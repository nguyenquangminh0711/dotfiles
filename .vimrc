"========================================================
" INSTALL PLUGINS
"========================================================
filetype off
call plug#begin('~/.vim/plugged')
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'tomtom/tcomment_vim'
Plug 'mg979/vim-visual-multi'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
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
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'
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
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

if has("autocmd")
  autocmd FileType jsonnet set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType vue set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType python set tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType proto set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType go set tabstop=4 shiftwidth=4 softtabstop=4
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
" CONFIG TELESCOPE GENERAL
"========================================================
lua <<EOF
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local layout_strategies = require('telescope.pickers.layout_strategies')
require('telescope').setup{
  defaults = {
    initial_mode = "insert",
    layout_strategy = "flex",
    sorting_strategy = "ascending",
    file_sorter = sorters.get_fzy_sorter,
    layout_defaults = {
      vertical = {
        preview_height = 0.5,
        mirror = true,
      },
      horizontal = {
      },
      flex = {
        flip_columns = 130
      }
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-n>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up
      },
      n = {
        ["<esc>"] = actions.close,
        ["<C-n>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up
      },
    },
  }
}
EOF
nnoremap <c-p> <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
"========================================================
" CONFIG TELESCOPE DIFF
"========================================================
lua <<EOF
local neogit = require('neogit')

neogit.setup {
  integrations = {
    diffview = true
  }
}
EOF
nnoremap <silent> <c-g> <ESC>:Neogit<CR>

lua <<EOF
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local defaulter = utils.make_default_callable
local putils = require('telescope.previewers.utils')

local git_file_diff = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git File Diff Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      if entry.status and (entry.status == '??' or entry.status == 'A ') then
        local p = from_entry.path(entry, true)
        if p == nil or p == '' then return end
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname
        })
      else
        local branch = opts.branch or 'master'
        putils.job_maker({ 'git', '--no-pager', 'diff', branch..'..HEAD', '--', entry.value }, self.state.bufnr, {
          value = entry.value,
          bufname = self.state.bufname,
          cwd = opts.cwd
        })
        putils.regex_highlighter(self.state.bufnr, 'diff')
      end
    end
  }
end, {})

function git_diff(opts)
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  local gen_new_finder = function()
    local branch = opts.branch or 'master'
    local git_cmd = {'git', 'merge-base', 'HEAD', branch}
    local output = utils.get_os_command_output(git_cmd, opts.cwd)

    if table.getn(output) == 0 then
      print('No changes found')
      return
    end

    local git_cmd = {'git', 'diff', '--name-only', output[1]}
    local output = utils.get_os_command_output(git_cmd, opts.cwd)

    if table.getn(output) == 0 then
      print('No changes found')
      return
    end

    return finders.new_table {
      results = output,
      entry_maker = make_entry.gen_from_file(opts)
    }
  end

  local initial_finder = gen_new_finder()
  if not initial_finder then return end

  pickers.new(opts, {
    prompt_title = 'Git diff',
    finder = initial_finder,
    previewer = git_file_diff.new(opts),
    sorter = conf.file_sorter(opts)
  }):find()
end
local builtin = require('telescope.builtin')
builtin.git_diff = git_diff
EOF
nnoremap <silent> <c-d> <ESC>:Telescope git_diff<CR>

lua <<EOF
local diffview = require('diffview')
local io = require 'io'

function _G.detail_diff()
  local output = vim.fn.system('git merge-base HEAD master')
  diffview.open(vim.trim(output))
end
EOF
nnoremap <silent> <leader>do <ESC>:call v:lua.detail_diff()<CR>
nnoremap <silent> <leader>dd <ESC>:DiffviewOpen<CR>
nnoremap <silent> <leader>dc <ESC>:DiffviewClose<CR>
"========================================================
" CONFIG TELESCOPE RECENT FILES
"========================================================
lua <<EOF
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local putils = require('telescope.previewers.utils')

function _G.recent_files(opts)
  local gen_new_finder = function()
    local output = vim.api.nvim_eval('FilterOldfiles(getcwd())')

    return finders.new_table {
      results = output,
      entry_maker = make_entry.gen_from_file(opts)
    }
  end

  local initial_finder = gen_new_finder()
  if not initial_finder then return end

  pickers.new(opts, {
    prompt_title = 'Recent files',
    finder = initial_finder,
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts)
  }):find()
end
EOF
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
nnoremap <silent> <C-r> <ESC>:call v:lua.recent_files({})<CR>
"========================================================
" CONFIG LSP
"========================================================
map gj <Nop>
map gx <Nop>
map gv <Nop>
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
  buf_set_keymap('n', 'gx', ':sp<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gv', ':vsp<CR><Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', ":lua require'telescope.builtin'.lsp_references{}<CR>", opts)
  buf_set_keymap('n', 'gi', ":lua require'telescope.builtin'.lsp_implementations{}<CR>", opts)
  buf_set_keymap('n', 'ga', ":lua require'telescope.builtin'.lsp_code_actions{}<CR>", opts)
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

highlight link esearchLineNr Comment
highlight link esearchCursorLineNr esearchFilename

" nmap <silent> <leader>ff <plug>(esearch)
nnoremap <silent> <leader>ff <cmd>Telescope live_grep<cr>
"========================================================
" CONFIG NERDTree
"========================================================
noremap <silent> <leader>nt <ESC>:NERDTreeToggle<CR>
noremap <silent> <leader>rev <ESC>:NERDTreeFind<CR>
let NERDTreeMapOpenSplit = 'x'
let NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeWinSize=50
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
let g:endwise_no_mappings = 1
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
