"========================================================
" INSTALL PLUGINS
"========================================================
filetype off
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jacoborus/tender.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'mbbill/undotree'
Plug 'ryanoasis/vim-devicons'
Plug 'janko-m/vim-test'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/git-time-lapse'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'Shougo/deoplete-clangx'
Plug 'w0rp/ale'
Plug 'fatih/vim-go'
Plug 'christoomey/vim-tmux-navigator'
Plug 'brooth/far.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'dbgx/lldb.nvim'
Plug 'iamcco/markdown-preview.vim'
Plug 'dbeniamine/cheat.sh-vim'
call plug#end()
"========================================================
" EDITOR CONFIGS
"========================================================
syntax on
filetype on
filetype indent on
filetype plugin on
set hlsearch
set ai
set ruler
set linespace=1
set gfn=DejaVu\ Sans\ Mono\ for\ Powerline:h13
let g:auto_ctags = 1
set breakindent
set nofoldenable
" set tags=./tags;,tags;
set ruler
set number
set expandtab
set autoindent
set clipboard=unnamed
set splitright
set splitbelow
set ttyfast
set lazyredraw
set laststatus=2
set encoding=utf8
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11
set background=dark
set bs=2 tabstop=2 shiftwidth=2 softtabstop=2
colorscheme tender
if (has("termguicolors"))
 set termguicolors
endif
" Fix iterm display
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

"========================================================
" CONFIG PYTHON
"========================================================
let g:python_host_prog = '/System/Library/Frameworks/Python.framework/Versions/2.7/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3.7'
"========================================================
" CONFIG ALE
"========================================================
let g:ale_fixers = {
\ 'ruby': ['rubocop']
\ }
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'c': ["clang"],
\}
let g:ale_c_clang_options = "-std=c11 -Wall"
let g:ale_lint_on_text_changed="never"
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
highlight SignColumn guibg=255
"========================================================
" CONFIG DEOPLETE
"========================================================
set completeopt+=noselect
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/deoplete-go'
let g:go_def_mode = "guru"
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#enable_ignore_case = 'ignorecase'
let g:deoplete#sources = {}
let g:deoplete#sources_ = ['buffer','tag']
let g:neosnippet#enable_completed_snippet = 1

imap <C-b> <Plug>(neosnippet_expand_or_jump)
smap <C-b> <Plug>(neosnippet_expand_or_jump)
xmap <C-b> <Plug>(neosnippet_expand_target)

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

inoremap <silent><expr> <TAB>
      \ neosnippet#expandable_or_jumpable() ?
      \ neosnippet#mappings#jump_or_expand_impl() :
      \ "\<TAB>"


call deoplete#custom#var('clangx', 'clang_binary', '/usr/bin/clang')
"========================================================
" CONFIG MISC
"========================================================
" Auto pair
let g:AutoPairsMultilineClose = 0
let g:indentLine_enabled = 0
" Tmux navigation
let g:tmux_navigator_no_mappings = 1
" Rpsec config
let test#strategy = "neovim"
" Solve vim ESC delay
set timeoutlen=1000 ttimeoutlen=0
if has("autocmd")
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType go set tabstop=8 shiftwidth=8 softtabstop=8
  autocmd FileType xml set equalprg=xmllint\ --format\ -
  autocmd BufWritePre * StripWhitespace
endif
let g:move_key_modifier = 'C'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.html.eex,*.html.erb"
let g:jsx_ext_required = 0
let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules'
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore node_modules -l -g ""'
let g:fzf_preview_source=" --preview='bat {}'"
"========================================================
" MAPPING FZF
"========================================================
map <c-p> <ESC>:call fzf#vim#files('.', {'options': g:fzf_preview_source})<CR>
map <silent> <leader>/ <ESC>:BLines<CR>
map <leader>ag <ESC>:Ag<space>
map <c-]> <ESC>:call fzf#vim#tags(expand("<cword>"), {'options': '--exact'})<cr>
"========================================================
" MAPPING NERDTree
"========================================================
map <silent> <leader>nt <ESC>:NERDTreeToggle<CR>
map <silent> <leader>rev :NERDTreeFind<CR>
let NERDTreeMapOpenSplit = 'x'
let NERDTreeMapOpenVSplit = 'v'
"========================================================
" MAPPING RSPEC
"========================================================
map <Leader>tt :TestFile<CR>
map <Leader>ts :TestNearest<CR>
map <Leader>tl :TestLast<CR>
map <Leader>ta :TestSuite<CR>
let test#ruby#rspec#executable = 'rspec'
"========================================================
" MAPPING EASYMOTION
"========================================================
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
"========================================================
" MAPPING EASYALIGN
"========================================================
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"========================================================
" MAPPING GIT
"========================================================
map <silent> <leader>gt :call TimeLapse() <cr>
"========================================================
" BOOKMARKS
"========================================================
let g:bookmark_save_per_working_dir = 1
let g:bookmark_highlight_lines = 1

function! BookmarkItem(line)
  let lnr = split(v:val, ":")
  return lnr[0].":".lnr[1].":0"."\t".join(lnr[2:], ":")
endfunction
function! BookmarksFZF()
    call fzf#vim#ag('', {'source': map(bm#location_list(), 'BookmarkItem(v:val)'), 'down': '30%', 'options': '--prompt "Bookmarks  >>>  "'})
endfunction
let g:bookmark_no_default_key_mappings = 1
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
function! BookmarkMapKeys()
    nmap mm :BookmarkToggle<CR>
    nmap mi :BookmarkAnnotate<CR>
    nmap mn :BookmarkNext<CR>
    nmap mp :BookmarkPrev<CR>
    nmap ma <ESC>:call BookmarksFZF()<CR>
    nmap mc :BookmarkClear<CR>
    nmap mx :BookmarkClearAll<CR>
    nmap mkk :BookmarkMoveUp
    nmap mjj :BookmarkMoveDown
endfunction
function! BookmarkUnmapKeys()
    unmap mm
    unmap mi
    unmap mn
    unmap mp
    unmap ma
    unmap mc
    unmap mx
    unmap mkk
    unmap mjj
endfunction
autocmd BufEnter * :call BookmarkMapKeys()
autocmd BufEnter NERD_tree_* :call BookmarkUnmapKeys()
map ma <ESC>:call BookmarksFZF()<CR>
"========================================================
" MAPPING MISC
"========================================================
nnoremap <silent> <CR> <ESC>:noh<CR>
map <silent> <leader>' cs'"
map <silent> <leader>" cs"'
map <silent> <leader>u :UndotreeToggle<CR>
map <silent> <C-h> <ESC>:TmuxNavigateLeft<CR>
map <silent> <C-l> <ESC>:TmuxNavigateRight<CR>
map <silent> <C-k> <ESC>:TmuxNavigateUp<CR>
map <silent> <C-j> <ESC>:TmuxNavigateDown<CR>
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
map <silent> <leader>path :let @+=@%<CR>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> <expr> ^ (v:count == 0 ? 'g^' : '^')
noremap <silent> <expr> $ (v:count == 0 ? 'g$' : '^')
if has("nvim")
  tnoremap <c-e> <C-\><C-n>
end
nmap <silent> <leader>t :TagbarToggle<CR>
let vim_markdown_preview_hotkey='<C-r>'
let vim_markdown_preview_github=1
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
" LLDB CONFIGS
"========================================================
nnoremap <silent> <leader>lld <ESC>:LLmode debug<CR>
nnoremap <silent> <leader>llc <ESC>:LLmode code<CR>
nnoremap <silent> <leader>lll <ESC>:LLsession load<CR>
nnoremap <silent> <leader>lc <ESC>:LL continue<CR>
nnoremap <silent> <leader>ln <ESC>:LL next<CR>
nnoremap <silent> <leader>ls <ESC>:LL step<CR>
nnoremap <silent> <leader>lp :LL print <C-R>=expand('<cword>')<CR>
vnoremap <silent> <leader>lp :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>
nmap <leader>lb <Plug>LLBreakSwitch
"========================================================
" STARTIFY CONFIGS
"========================================================
let g:startify_change_to_dir = 0
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
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
