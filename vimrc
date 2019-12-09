" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
" ----------------------------

" Allow use of the cursor
" set mouse=a
" no <ScrollWheelUp> <C-Y>
" no <ScrollWheelDown> <C-E>
" inoremap <ScrollWheelUp> <C-Y>
" inoremap <ScrollWheelDown> <C-E>

" Set scroll offset to be 5 from the top or bottom of window
set scrolloff=5

set undodir=~/.hist/vim
set undofile

" Use the system clipboard
" set clipboard=unnamedplus

" Disable visual bell and beeping
" Note: Nvim doesn't have special t_XX options for terminal config
"       instead treats terminal like any other UI
set vb t_vb:

" Disable swapfiles
set noswapfile
" Disable wrap around file during search
set nowrapscan
" Disable .viminfo
set viminfo=""

" Allow fold method to be determined by the language
set foldmethod=syntax
" But don't fold on file open
set foldlevel=99
set foldlevelstart=99

" Don't give the intro message when starting vi
set shortmess+=IF

" Highlight matches to search queries
set hlsearch

" Highlight search query matches as typed
set incsearch

" ...but can be reset by pressing <C-L>
nnoremap <C-L> :noh<CR><C-L>

" Enable no-show mode, disabling the -- INSERT -- shown when in Insert mode
set noshowmode

" Use plugins to identify the filetype of a given file extension name
filetype plugin indent on

" Show confirmation prompt when exiting vim
set confirm

" Customize the status line that appears at the bottom
set statusline=%F\ -\ FileType:\ %y

" Set the status line to always show
set laststatus=2

" Add line numbers
set number

" View tabs as 2 spaces
set tabstop=2

" Have a visual column at line 81
set colorcolumn=81

" Make text that extends past the visual column faded grey
autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
autocmd BufEnter * match OverLength /\%81v.*/

" Enable soft tabs, with each soft tab making 2 spaces
set softtabstop=2

" Hitting tab in insert mode will produce the appropriate number of spaces
set expandtab

" Use zsh as the default shell
set sh=zsh

" Control how many columns text is indented with using reindent operations
set shiftwidth=2

" Searches ignore case
set ignorecase

" Allow the cursor to wrap around from one line to the previous one
set whichwrap=b,s,h,l,<,>,[,]

" Set vertical splits to open on the right side of the terminal
set splitright

" Set horizontal splits to open on the bottom side of the terminal
set splitbelow

" Allow backspace to delete over autoindents, line breaks, & old content
set backspace=indent,eol,start

" Open Vexplore windows to take up 15% of the window width
let g:netrw_winsize = 15

" Set scroll-up and scroll-down to change view-port not cursor position
" nnoremap OA <C-y>
" nnoremap OB <C-e>

" Set help mode to always open in a new tab
command -nargs=1 H tab help <args>

" Set a command 'MD' to open markdown preview

" Write buffer to a:file as the super user (on POSIX, root). {{{2
command W silent exec 'write !sudo tee ' . shellescape(@%:p, 1) . '> /dev/null'

" Remap scrolling keys in insert mode
inoremap OA <C-c><C-y>
inoremap OB <C-c><C-e>

" Allow enter to create a newline in normal mode
" nnoremap <CR> o<C-c>
nnoremap <Bslash>p G
nnoremap <Bslash>o dd

" Allow deletion of text in normal mode
nnoremap  X

" Allow repeating commands in visual mode
vnoremap . :normal .<CR>

" Rebind entering normal mode
inoremap \j <C-c>l
cnoremap \j <C-c>
vnoremap \j <C-c>

" Allow moving to the beginning and end of the line with readline syntax
inoremap <C-A> <HOME>
inoremap <C-E> <END>
cnoremap <C-A> <HOME>
cnoremap <C-E> <END>

" Allow for * and ? to wrap around and use smart case insensitivity
nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>

" <A-n> will execute the absolute path to the current file
nnoremap N :!%:p<CR>

" Allow moving forward and backward without the arrow keys with readline syntax
inoremap <C-F> <Right>
cnoremap <C-F> <Right>
inoremap <C-B> <Left>
cnoremap <C-B> <Left>
cnoremap b <S-Left>
cnoremap f <S-Right>
inoremap b <C-o>B
inoremap f <C-o>W


" Allow deleting characters with readline syntax
inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
inoremap d <C-o>dW<Space>

" Allow pasting lines with readline syntax
cnoremap <C-Y> <C-R>-

" [leader Customizations]
" -----------------------
let mapleader=' '
" Quickly write files
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>t :tabnew<CR>:e<Space>
nnoremap <leader>? :help<Space>
" Quickly copy to the clipboard
nnomap <leader>y "*y
vnomap <leader>y "*y
nnomap <leader>x "*D
vnomap <leader>y "*D
" Quickly switch tabs
nnoremap <leader>{ gT
nnoremap <leader>} gt
" Open current window in a new tab
nnoremap <leader>O <C-w>T
" Quickly open a new split window
nnoremap <leader>n :vs new<CR>:e<Space>
nnoremap <leader>m :sp new<CR>:e<Space>
" Allow for easier access of ex-commands
nnoremap <leader>; :
" Allow for easier line deletion
nnoremap <leader>d dd
" Allow for easier macro execution
nnoremap <leader>2 @
" Open vimrc in side pane
nnoremap <leader>r :vsplit ~/.vimrc<CR>

" Set help menu to open in vertical split
aug helpfiles
  au!
  au BufEnter */doc/* if &filetype=='help' | winc L | endif
aug END

" Automatically delete all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

au BufEnter,BufNewFile,BufRead shrc,.shrc,util,.util set ft=sh
au BufEnter,BufNewFile,BufRead */tmux/config set ft=tmux
au BufEnter,BufNewFile,BufRead *.asc call feedkeys("\<C-l>")

" Enable hard tabs for certain languages
au FileType zsh,sh,make setlocal noexpandtab
au FileType zsh,sh,make setlocal softtabstop=0

" Set vimdiff to accept (1, 2, 3) for commit choices
if &diff
    map <leader>1 :diffget LOCAL<CR>
    map <leader>2 :diffget BASE<CR>
    map <leader>3 :diffget REMOTE<CR>
endif

map ; <Plug>Sneak_;
map , <Plug>Sneak_,
xmap ; <Plug>Sneak_;
xmap , <Plug>Sneak_,

" packloadall
" packadd onedark
packadd lightline

" Set linting UI
" let g:ale_sign_error = '>'
" let g:ale_sign_warning = '>'

" Set linting hotkeys
" nmap <silent> <leader>f :ALENext<cr>
" nmap <silent> <leader>b :ALEPrevious<cr>

" Disable format options
" -c Disable autowrap comment
" -r Disable auto-commenting out the next line inserted
" -o Disables a new comment when using 'O' in normal mode
autocmd FileType * setlocal formatoptions-=cro


" Enable syntax highlighting for markdown code
" blocks for the following languages
let g:markdown_fenced_languages = ['sql', 'cpp', 'c', 'java', 'js=javascript',
      \ 'py=python', 'rb=ruby', 'sh', 'css', 'html', 'json',
      \ 'less', 'liquid', 'make', 'perl', 'php', 'vim', 'yaml', 'sass', 'scss']
" Turn on markdown syntax highlighting for code snipps <= 100 lines long
let g:markdown_minlines = 100

" Turn on syntax highlighting
syntax on
" Use minimal color scheme
colorscheme paramount

" Disable highlighting for sneak
hi! link Sneak Normal
