" _       _ _         _
"(_)_ __ (_) |___   _(_)_ __ ___
"| | '_ \| | __\ \ / / | '_ ` _ \
"| | | | | | |_ \ V /| | | | | | |
"|_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
" Author: Cameron Durham
" Email: polytime@icloud.com
" Site: https://polytime.space

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DEFAULTS:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number          " show line numbers
let mapleader = " "
set cursorline		" highlight current line
set expandtab		" always use spaces over tabs
set softtabstop=4   " use soft tabs with 2 spaces
set tabstop=4       " view tabs as 2 space
set shiftwidth=4    " let indent be 2 spaces
set ignorecase      " make search ignore case
set undodir=~/.hist/nvim
set undofile
set autochdir       " set workingdir wherever open file lives
" manually toggle with `:set autochdir!`

let g:use_line_guard = 0 " highlight lines over 80 characters

autocmd BufReadPost *.rs setlocal filetype=rust

autocmd FileType *.cpp *.c setlocal cindent

set splitright      " vertical splits always open on right
set splitbelow      " make horizontal splits always open below

set wildmenu        " command-line completion in vim

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,

" `gf` opens file under cursor in a new vertical split
" nnoremap gf :vertical wincmd f<CR>


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
Plug 'axelf4/vim-strip-trailing-whitespace'
Plug 'tmsvg/pear-tree'
" Plug 'tpope/vim-markdown'
Plug 'tpope/vim-vinegar'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
call plug#end()

" ENVIRONMENT VARIABLES
"   IMPORTANT: Required by deoplete/LanguageClient_neovim
let g:python3_host_prog = '/usr/local/anaconda3/bin/python3'
let g:python_host_prog = '/usr/local/bin/python2'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYMAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" redraw screen and unhighlight searches
nnoremap <C-l> :noh<cr>
vnoremap <C-l> <esc>:noh<cr>
inoremap <C-l> <esc>:noh<cr>i


" compile simple c++ program
nnoremap <f8> :w <cr> :!g++ -std=c++11 -Wall % -o %<.o && ./%<.o <cr>

"   set scroll-up and scroll-down
" to vim window not terminal window
set mouse=nicr          "   enable mouse in normal,
" insert, cmd, replace modes
" set nowrap            "   disable line wrapping
" (so there's something to scroll to)

" set escape shortcut key
" Note: inoremap jk <esc> " commenting here makes bad sh*t happen
inoremap jk <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LEADER KEYMAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" uppercase word in normal mode
nnoremap <leader>u <esc>viwUea

" Edit Vim or switch to tab if already open
" see :help myvimrc for environment variables
" :drop edits or jumps to file if open
" inoremap <leader>ev <esc>:tab drop $MYVIMRC<cr>
nnoremap <leader>ev :tab drop $MYVIMRC<cr>

" Source Vim
nnoremap <leader>so :source $MYVIMRC<cr>

" delete line
nnoremap <leader>d dd
" clear line
nnoremap <leader>c ddO

" make current uppercase
nnoremap <leader>u viwU

" rot13 the whole file
" nnoremap <leader>g mmggg?G`m

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" surround the word in single quotes
nnoremap <leader>' viw'<esc>bi'<esc>lel
vnoremap <leader>' <esc>`<i'<esc>`>a'<esc>

" toggle color column
nnoremap <leader>cc :call ToggleCC()<cr>

" toggle wrap
nnoremap <leader>w :call ToggleWrap()<cr>

" jump into file-wide substitute
nnoremap <leader>S :%s///g <left><left><left><left>

" jump into line substitute
nnoremap <leader>s :s///g <left><left><left><left>

" jump to next <++> marker
nnoremap <leader><leader> /<++><cr>ce

" intent file and return to current location
inoremap <leader><leader>i mmgg=G`m
nnoremap <leader><leader>i mmgg=G`m

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Open current file in chrome
nnoremap <F12> :exe ':silent !open -a "Google Chrome" %'<CR>


" Set 'formatoptions' (aka 'fo') to break comment lines but not other lines
" and not insert comment leader on <CR>
" add insert when using "o" with fo+=o
autocmd FileType * setlocal fo-=c fo-=r fo-=o

" ABBREVIATIONS
iabbrev @@ polytime@icloud.com

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
nnoremap <leader>z <esc>:Ack!  ~/Dropbox/notes/ <c-b><c-b><right><right><right><right>

" DEOPLETE
" Use deoplete.
" autocmd FileType *.cpp *.rs *.py let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 1

" autocmd FileType *.cpp *.rs *.py setlocal omnifunc=tern#Complete

call deoplete#custom#option('sources', {
            \ 'rust': ['LanguageClient'],
            \ 'cpp': ['LanguageClient'],
            \ 'python': ['LanguageClient']
            \ })

" NEOSNIPPET

"" Plugin key-mappings.
"" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)


"set completeopt-=preview

"" Enable snipMate compatibility feature.
"let g:neosnippet#enable_snipmate_compatibility = 1

let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_complete_done = 1


let g:neosnippet#snippets_directory='~/dot/nvim/plugin/snippets'

" LANGUAGECLIENT-NEOVIM
" Required for operations modifying multiple buffers like rename.
set hidden


" LANG-SERVER: CPP CONFIGURATION

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
            \ '\.rs$':  {'ale_enabled' : 0},
            \ '\.py$':  {'ale_enabled' : 0},
            \}

" LANG-SERVER: RUST CONFIGURATION
" See https://github.com/autozimu/LanguageClient-neovim
"
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ 'cpp': ['clangd'],
            \ 'c': ['clangd'],
            \ 'python': ['/usr/local/bin/pyls'],
            \ }

" Rust format on save:
let g:rustfmt_autosave = 1


" Stop annoying diagnostics sign popups, use virtual text with prefix instead
" source: https://github.com/L0stLink/anvil/blob/master/settings/LanguageClient-neovim.vim

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Open menu for language options
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>c :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> <leader>e :call LanguageClient#explainErrorAtPoint()<CR>

" Automatically map <BS>, <CR>, and <Esc>
let g:pear_tree_map_special_keys = 1

" VIM-MARKDOWN
let g:markdown_fenced_languages = [ 'html', 'python', 'bash=sh', 'c++=cpp', 'viml=vim']

" lets `ge` command foollow named anchors like
" file#anchor or #anchor
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

" follow links with implicit .md
" open [link text](link-url) open link-url.md
let g:vim_markdown_no_extensions_in_markdown = 1

let g:vim_markdown_autowrite = 1

let g:vim_markdown_edit_url_in = 'tab'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open file or jump if already open
command! -nargs=1 -complete=file O tab drop <args>

" Set help mode to always open in new tab
command! -nargs=1 H tab help <args>

" Set help menu to open in vertical split
aug helpfiles
    au!
    au BufEnter */doc/* if &filetype=='help' | winc L | endif
aug END

" Automatically delete all trailing whitespace on save.
" Not using compatibility problem when working in team git repos
" use :StripTrailingWhitespace to force
" autocmd BufWritePre * %s/\s\+$//e

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim). (thoughtbot)
autocmd BufReadPost *
            \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

" Turn on spell check for markdown files
aug spelling
    au!
    au BufEnter *.md setlocal spell spelllang=en_us
aug END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMSCRIPT FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! FileExists(FileName)
    return !empty(glob(a:FileName))
endfunction

function! SetLineGuard()
    if exists('+colorcolumn')
        " clear color column
        set cc=

        " highlight up to 255 cols, the max in Vim (?)
        " credits to the good people of vi-stackexchange:
        " https://bit.ly/35XMfIM
        let &colorcolumn="76,".join(range(77,500),",")
        hi ColorColumn ctermbg=darkgrey
    endif
endfunction

" ColorColumn (cc) is the variable for visual columns
" Must use syntax call <FUNC_NAME>() to use viml functions
" https://tinyurl.com/vy4j37l
function! ToggleCC()
    " if &cc == ''
    if g:use_line_guard
        let g:use_line_guard = 0
        set cc=
        echom("Toggle CC off")
    else
        let g:use_line_guard = 1
        call SetLineGuard()
        echom("Toggle CC on")
    endif
endfunction

function! ToggleWrap()
    if &wrap == 0
        set wrap
        echom("Toggle Line Wrap On")
    else
        set nowrap
        echom("Toggle Line Wrap Off")
    endif
endfunction

" Compile basic C++ programs
function! CompileCPP()
    " TODO
    echom 'LOL not finished yet :)'
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VISUAL CUSTOMIZATION AUGROUPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme paramount        " other fav is monochrome

if has('folding')
    if has('windows')
        set fillchars=vert:┃  " BOX DRAWINGS VERTICAL (U+2503)
        " for unbroken window lines
    endif
    set foldmethod=indent     " DUMBEST BUT FASTEST FOLD METHOD
    set foldlevelstart=99
endif


" Open Vexplore windows to take up 15% of the window width
" let g:netrw_winsize = 15

" Open netrw file in vertical split
" :h netrw-v and :h netrw_altv
" let g:netrw_altv=1

" Always set colorcolumn initially
aug line_guard
    au!
    set cc=
    if g:use_line_guard
        call SetLineGuard()
    endif
aug END
