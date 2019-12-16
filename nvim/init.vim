" _       _ _         _
"(_)_ __ (_) |___   _(_)_ __ ___
"| | '_ \| | __\ \ / / | '_ ` _ \
"| | | | | | |_ \ V /| | | | | | |
"|_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
" Author: Cameron Durham
" Email: polytime@icloud.com

" DEFAULTS:
set number
let mapleader = " "
set cursorline		" highlight current line
set expandtab		" always use spaces over tabs
set softtabstop=4   " use soft tabs with 2 spaces
set tabstop=4       " view tabs as 2 space
set shiftwidth=4    " let indent be 2 spaces
set ignorecase      " make search ignore case

autocmd BufReadPost * set formatoptions-=cro
                    " newlines shouldn't make new lines
autocmd BufReadPost *.rs setlocal filetype=rust

set splitright      " vertical splits always open on right
set splitbelow      " make horizontal splits always open below

" ENVIRONMENT VARIABLES
let g:python3_host_prog = '/usr/bin/python3'

" KEYMAPS

" redraw screen and unhighlight searches
nnoremap <C-l> :noh<cr>
vnoremap <C-l> <esc>:noh<cr>
inoremap <C-l> <esc>:noh<cr>i

"   set scroll-up and scroll-down
" to vim window not terminal window
set mouse=nicr          "   enable mouse in normal,
                        " insert, cmd, replace modes
" set nowrap            "   disable line wrapping
                        " (so there's something to scroll to)

" set escape shortcut key
" Note: above comment cannot go after mapping
inoremap jk <esc>

" LEADER KEYMAPS
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


" ABBREVIATIONS
iabbrev @@ polytime@icloud.com

" PACKAGES

" FYI: cannot add to runtimepath
" Packages searched for in: ~/.local/share/nvim/site/pack

" LanguageClient-neovim
" Required for operations modifying multiple buffers like rename.
set hidden


" Rust format on save:
let g:rustfmt_autosave = 1

" LANG-SERVER: RUST CONFIGURATION
" See https://github.com/autozimu/LanguageClient-neovim
"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'cpp': ['clangd']
\ }

" Don't show inline errors. See:
" https://github.com/autozimu/LanguageClient-neovim/issues/719
let g:LanguageClient_useVirtualText=0

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
" }}}


" COMMANDS

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

" VISUAL CUSTOMIZATION

colorscheme paramount

if has('folding')
	if has('windows')
		set fillchars=vert:┃		" BOX DRAWINGS VERTICAL (U+2503) for unbroken window lines
	endif
	set foldmethod=indent     " DUMBEST BUT FASTEST FOLD METHOD
	set foldlevelstart=99
endif


if exists('+colorcolumn')
	" highlight up to 255 cols (the current Vim Max, check for Nvim)
	" beyond 'textwidth'
	" let &l:colorcolumn='+'.join(range(0,254, ',+')
        let &l:colorcolumn=+61
        hi ColorColumn ctermbg=lightgrey guibg=lightgrey

endif

" Open Vexplore windows to take up 15% of the window width
let g:netrw_winsize = 15

" Vimscript functions

function! FileExists(FileName)
	return !empty(glob(a:FileName))
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" set statusline+=%{LinterStatus()}
