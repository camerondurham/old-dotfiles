" _       _ _         _
"(_)_ __ (_) |___   _(_)_ __ ___
"| | '_ \| | __\ \ / / | '_ ` _ \
"| | | | | | |_ \ V /| | | | | | |
"|_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
" Author: Cameron Durham
" Email: polytime@icloud.com
" Site: https://camerondurham.github.io

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DEFAULTS:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number          " show line numbers
let mapleader = " "
" set cursorline		" highlight current line
set expandtab		" always use spaces over tabs
set softtabstop=4   " use soft tabs with 2 spaces
set tabstop=4       " view tabs as 2 space
set shiftwidth=4    " let indent be 2 spaces
set ignorecase      " make search ignore case

set undofile
set autochdir       " set workingdir wherever open file lives
" manually toggle with `:set autochdir!`

filetype plugin on

" set indents to two spaces
autocmd FileType *.c setlocal softtabstop=2
autocmd FileType *.c setlocal tabstop=2
autocmd FileType *.c setlocal shiftwidth=2
autocmd FileType *.h setlocal softtabstop=2
autocmd FileType *.h setlocal tabstop=2
autocmd FileType *.h setlocal shiftwidth=2

autocmd BufReadPost *.rs setlocal filetype=rust

" brittle personal settings

let g:spell_check_markdown = 0
let g:load_plugins = 1
let g:my_machine = 1

" -----------


set splitright      " vertical splits always open on right
set splitbelow      " make horizontal splits always open below

set wildmenu        " command-line completion in vim

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,

" `gf` opens file under cursor in a new vertical split
" nnoremap gf :vertical wincmd f<CR>

if g:load_plugins
    source ~/dot/nvim/plugin/plugins.vim
endif

if g:my_machine
    set undodir=~/.hist/nvim
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYMAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" redraw screen and unhighlight searches
nnoremap <C-l> :noh<cr>
vnoremap <C-l> <esc>:noh<cr>
inoremap <C-l> <esc>:noh<cr>i

" trying out how well this works
inoremap {<CR> {<CR>}<Esc>O


" compile simple c++ program -- csci104 compliant
autocmd filetype cpp nnoremap <f8> :w <cr> :!g++ -std=c++11 -Wall % -o %<.o && ./%<.o <cr>

" from William Lin's github repo -- codejam compliant
"   %:r is a filename modifier in vim that strips the extension
"       ex: A.cpp becomes A
"   --stack specifies the allowed stack size in the running program (?)
autocmd filetype cpp nnoremap <f9> :w <bar> !g++ -std=c++14 % -o %:r.o -Wall<CR>


"   set scroll-up and scroll-down
" to vim window not terminal window
set mouse=nicr          "   enable mouse in normal,
" insert, cmd, replace modes
" set nowrap            "   disable line wrapping
" (so there's something to scroll to)

" set escape shortcut key
" Note: inoremap jk <esc> " commenting here makes bad sh*t happen
" inoremap jk <esc>

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

" use php/html filetypes easier
nnoremap <leader>h :set ft=html<cr>
nnoremap <leader>p :set ft=php<cr>

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" surround the word in single quotes
nnoremap <leader>' viw'<esc>bi'<esc>lel
vnoremap <leader>' <esc>`<i'<esc>`>a'<esc>

" toggle wrap
nnoremap <leader>w :call ToggleWrap()<cr>

" jump into file-wide substitute
nnoremap <leader>S :%s///g <left><left><left><left>

" jump into line substitute
nnoremap <leader>s :s///g <left><left><left><left>

" jump to next <++> marker
nnoremap <leader><leader> /<++><cr>ce

" intent file and return to current location
nnoremap <leader><leader>i mmgg=G`m

" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

nnoremap <leader>= <C-w>=

" Open current file in chrome
nnoremap <F12> :exe ':silent !open -a "Firefox Nightly" %'<CR>


" Set 'formatoptions' (aka 'fo') to break comment lines but not other lines
" and not insert comment leader on <CR>
" add insert when using "o" with fo+=o
autocmd FileType * setlocal fo-=c fo-=r fo-=o

" ABBREVIATIONS
" iabbrev @@ cameronrdurham@gmail.com


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

autocmd BufWritePre * %s/\s\+$//e

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
    if g:spell_check_markdown
        au BufEnter *.md setlocal spell spelllang=en_us
    endif
aug END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMSCRIPT FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ToggleWrap()
    if &wrap == 0
        set wrap
        echom("Toggle Line Wrap On")
    else
        set nowrap
        echom("Toggle Line Wrap Off")
    endif
endfunction



if has('folding')
    if has('windows')
        set fillchars=vert:┃  " BOX DRAWINGS VERTICAL (U+2503)
        " for unbroken window lines
    endif
    set foldmethod=indent     " DUMBEST BUT FASTEST FOLD METHOD
    set foldlevelstart=99
endif
