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
set number
let mapleader = " "
set cursorline		" highlight current line
set expandtab		" always use spaces over tabs
set softtabstop=4   " use soft tabs with 2 spaces
set tabstop=4       " view tabs as 2 space
set shiftwidth=4    " let indent be 2 spaces
set ignorecase      " make search ignore case
set undodir=~/.hist/nvim
set undofile


autocmd BufReadPost *.rs setlocal filetype=rust

set splitright      " vertical splits always open on right
set splitbelow      " make horizontal splits always open below

" ENVIRONMENT VARIABLES
"   Required by deoplete/LanguageClient_neovim
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYMAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" redraw screen and unhighlight searches
nnoremap <C-l> :noh<cr>
vnoremap <C-l> <esc>:noh<cr>
inoremap <C-l> <esc>:noh<cr>i

" toggle color column
nnoremap <leader>cc :call ToggleCC()<cr>

" toggle wrap
nnoremap <leader>w :call ToggleWrap()<cr>

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


" Set 'formatoptions' to break comment lines but not other lines
" and not insert comment leader on <CR> but insert when hitting or using "o"
autocmd FileType * setlocal fo-=cr fo+=oql

" ABBREVIATIONS
iabbrev @@ polytime@icloud.com

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" FYI: cannot add to runtimepath
" Packages searched for in: ~/.local/share/nvim/site/pack


" DEOPLETE
" Use deoplete.
autocmd FileType *.cpp *.rs let g:deoplete#enable_at_startup = 1

" LanguageClient-neovim
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

autocmd BufEnter *.cpp let g:ale_enabled = 0
autocmd BufEnter *.rs let g:ale_enabled = 0

" LANG-SERVER: RUST CONFIGURATION
" See https://github.com/autozimu/LanguageClient-neovim
"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'cpp': ['clangd'],
    \ 'python': ['/usr/local/bin/pyls'],
\ }


" Rust format on save:
let g:rustfmt_autosave = 1

" Don't show inline errors. See:
" https://github.com/autozimu/LanguageClient-neovim/issues/719
" let g:LanguageClient_useVirtualText=1

" Stop annoying diagnostics sign popups, use virtual text with prefix instead
" source: https://github.com/L0stLink/anvil/blob/master/settings/LanguageClient-neovim.vim
let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_useVirtualText = 1
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_virtualTextPrefix = "    ••➜ "
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "location-list"
let g:LanguageClient_hoverpreview = "Always"


" Language Server Status

" Bindings for LanguageClient-neovim
augroup bind_ls_actions
    autocmd!
    " Use language server with supported file types
    autocmd FileType javascript,python setlocal omnifunc=LanguageClient#complete
    " Update lightline on LC diagnostic update
    autocmd User LanguageClientDiagnosticsChanged call lightline#update()
augroup end
"""

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Open menu for language options
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>c :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> <leader>e :call LanguageClient#explainErrorAtPoint()<CR>




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
autocmd BufWritePre * %s/\s\+$//e

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim). (thoughtbot)
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif


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
        let &colorcolumn="80,".join(range(81,255),",")
        hi ColorColumn ctermbg=darkgrey
    endif
endfunction


" ColorColumn (cc) is the variable for visual columns
" Must use syntax call <FUNC_NAME>() to use viml functions
" https://tinyurl.com/vy4j37l
function! ToggleCC()
    if &cc == ''
        call SetLineGuard()
    else
        set cc=
    endif
endfunction

function! ToggleWrap()
    if &wrap == 0
        set wrap
    else
        set nowrap
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

colorscheme paramount

if has('folding')
	if has('windows')
		set fillchars=vert:┃  " BOX DRAWINGS VERTICAL (U+2503)
                              " for unbroken window lines
	endif
	set foldmethod=indent     " DUMBEST BUT FASTEST FOLD METHOD
	set foldlevelstart=99
endif


" Open Vexplore windows to take up 15% of the window width
let g:netrw_winsize = 15

aug line_guard
    au!
    set cc=
    call SetLineGuard()
aug END
