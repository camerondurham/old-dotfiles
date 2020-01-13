" source: https://vimways.org/2019/personal-notetaking-in-vim/

" allows you to create new timestamped note in Vim:
" :Zet a new note -> ~/Dropbox/notes/2020-01-04-0940-new-note.md
func! local#zettel#edit(...)

    " build file name
    let l:sep = ''
    if len(a:000) > 0
        let l:sep = '-'
    endif
    let l:fname = expand('~/Dropbox/notes/') . strftime("%F-%H%M") . l:sep . join(a:000, '-') . '.md'

    " edit the new file
    exec "e " . l:fname

    " enter title and timestamp (using ultisnips) in the new file
    if len(a:000) > 0
        exec "normal gg0\<c-r>=strftime('%Y-%m-%d %H:%M')\<cr> " . join(a:000) . "\<cr>\<esc>G"
    else
        exec "normal gg0\<c-r>=strftime('%Y-%m-%d %H:%M')\<cr>\<cr>\<esc>G"
    endif

endfunc
