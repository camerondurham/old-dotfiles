func! local#ccp#edit(...)

    " build file name
    let l:sep = ''
    if len(a:000) > 0
        let l:sep = '_'
    endif
    let l:fname = expand('$CP_PRACTICE/') . join (a:000, '_') . '.cpp'
    let l:temp = expand('$CP_PRACTICE/cp_template.cpp')

    " copy the file
    exec "! cp " . l:temp . " " . l:fname

    " edit the new file
    exec "e " . l:fname

endfunc

