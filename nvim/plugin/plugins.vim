
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if ! filereadable(expand('$DOTFILES/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    " silence output from command
    silent !mkdir -p ~/dot/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/dot/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/dot/nvim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
Plug 'dense-analysis/ale'

Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

Plug 'mileszs/ack.vim'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'gkeep/iceberg-dark'
Plug 'itchyny/lightline.vim'
Plug 'cocopon/iceberg.vim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" FYI: cannot add to runtimepath
" Packages searched for in: ~/.local/share/nvim/site/pack

" ACK.VIM
" Usage
" :Ack [options] {pattern} [{directories}]


" Don't jump to first result immediately
cnoreabbrev Ack Ack!

" search in notes directory
nnoremap <leader>z <esc>:Ack! /Users/camerondurham/Google\ Drive\ File\ Stream/My\ Drive/notes/ <c-b><c-b><right><right><right><right>

" I guess f for find???
nnoremap <leader>f <esc>:Ack!  ./ <c-b><c-b><right><right><right><right>

" DEOPLETE
" Use deoplete.
" autocmd FileType *.cpp *.rs *.py let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 1

" autocmd FileType *.cpp *.rs *.py setlocal omnifunc=tern#Complete

call deoplete#custom#option('sources', {
            \ 'rust': ['LanguageClient'],
            \ 'cpp': ['LanguageClient'],
            \ 'python': ['LanguageClient'],
            \ 'c' : ['LanguageClient'],
            \ 'javascript' : ['LanguageClient']
            \ })

" ALE

" https://github.com/dense-analysis/ale/issues/1176
" Don't check executables multiple times and cache loading failure/success
let g:ale_cache_executable_check_failures = 1

" choose which ale linters to use
let g:ale_linters = { 'tex' : ['chktex', 'lacheck', 'proselint', 'texlab', 'vale']}

" ----------

" NEOSNIPPET

"" Plugin key-mappings.
"" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)


set completeopt-=preview

"" Enable snipMate compatibility feature.
"let g:neosnippet#enable_snipmate_compatibility = 1

let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_complete_done = 1

let g:neosnippet#snippets_directory='~/dot/nvim/plugin/snippets'

" ----------

" LANGUAGECLIENT-NEOVIM
" Required for operations modifying multiple buffers like rename.

set hidden

"   IMPORTANT: Required by deoplete/LanguageClient_neovim
let g:python3_host_prog = '/usr/local/opt/python@3.8/bin/python3.8'
let g:python_host_prog = '/usr/local/bin/python2'

" lang-server: cpp configuration
" Disable ALE for all LanguageClient clients
if executable('clangd')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd', '-background-index']},
                \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                \ })
endif


" Disable ALE for LC_neovim clients
" see :helpgrep ale_pattern_options for more info
let g:ale_pattern_options = {
            \ '\.cpp$': {'ale_enabled' : 0},
            \ '\.c$': {'ale_enabled' : 0},
            \ '\.h$': {'ale_enabled' : 0},
            \ '\.hpp$': {'ale_enabled' : 0},
            \ '\.rs$':  {'ale_enabled' : 0},
            \ '\.py$':  {'ale_enabled' : 0},
            \ '\.md$':  {'ale_enabled' : 0},
            \}

" LANG-SERVER: RUST CONFIGURATION
" See https://github.com/autozimu/LanguageClient-neovim
"
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ 'cpp': ['clangd'],
            \ 'c': ['clangd'],
            \ 'python': ['/usr/local/bin/pyls'],
            \ 'javascript' : ['javascript-typescript-stdio'],
            \ 'typescript' : ['javascript-typescript-stdio'],
            \ }

let g:LanguageClient_changeThrottle = 1
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_useVirtualText = "All"
let g:LanguageClient_virtualTextPrefix = "    ••➜ "
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "location-list"
let g:LanguageClient_hoverpreview = "Always"



" Rust format on save:
let g:rustfmt_autosave = 1


" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Turn off all syntax checking
nnoremap <leader>O <esc>:LanguageClientStop<CR><esc>:ALEDisable<CR>
vnoremap <leader>O <esc>:LanguageClientStop<CR><esc>:ALEDisable<CR>

" Open menu for language options
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>c :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> <leader>e :call LanguageClient#explainErrorAtPoint()<CR>

" ----------



" VIM-MARKDOWN
let g:markdown_fenced_languages = [ 'html', 'python', 'bash=sh', 'c++=cpp', 'viml=vim']

" lets `ge` command follow named anchors like
" file#anchor or #anchor
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

" follow links with implicit .md
" open [link text](link-url) open link-url.md
let g:vim_markdown_no_extensions_in_markdown = 1

let g:vim_markdown_autowrite = 1

let g:vim_markdown_edit_url_in = 'tab'

" ----------


" STATUSLINE

if !has('gui_running')
  set t_Co=256
endif

" get rid of --INSERT -- since it's not needed anymore
set noshowmode


colorscheme iceberg
let g:lightline = { 'colorscheme': 'icebergDark' }

hi Normal guibg=NONE ctermbg=NONE

" ----------



