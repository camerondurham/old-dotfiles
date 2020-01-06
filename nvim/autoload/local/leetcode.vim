func! local#leetcode#edit(...)

    " build file name
    let l:sep = ''
    if len(a:000) > 0
        let l:sep = '_'
    endif
    " let l:fname = expand('~/projects/practice/cpp/leetcode/') . join (a:000, '_') . '.cpp'
    let l:fname = expand('$PRACTICE_CPP_LEETCODE/') . join (a:000, '_') . '.cpp'
    let l:temp = expand('$PRACTICE_CPP_LEETCODE/leetcode_template.cpp')

    " copy the file
    exec "! cp " . l:temp . " " . l:fname

    " edit the new file
    exec "e " . l:fname

endfunc

