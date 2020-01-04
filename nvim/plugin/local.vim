" from: https://vimways.org/2019/personal-notetaking-in-vim/
" creates a timestamped file in notes directory
command! -nargs=* Zet call local#zettel#edit(<f-args>)
