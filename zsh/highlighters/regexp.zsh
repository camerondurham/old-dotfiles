# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# List of keyword and color pairs.
typeset -gA ZSH_HIGHLIGHT_REGEXP

# Whether the pattern highlighter should be called or not.
_zsh_highlight_highlighter_regexp_predicate()
{
  _zsh_highlight_buffer_modified
}

# Pattern syntax highlighting function.
_zsh_highlight_highlighter_regexp_paint()
{
  setopt localoptions extendedglob
  local pattern
  for pattern in ${(k)ZSH_HIGHLIGHT_REGEXP}; do
    _zsh_highlight_regexp_highlighter_loop "$BUFFER" "$pattern"
  done
}

_zsh_highlight_regexp_highlighter_loop()
{
  local buf="$1" pat="$2"
  integer OFFSET=0
  local MATCH; integer MBEGIN MEND
  local -a match mbegin mend
  while true; do
    [[ "$buf" =~ "$pat" ]] || return;
    region_highlight+=("$((MBEGIN - 1 + OFFSET)) $((MEND + OFFSET)) $ZSH_HIGHLIGHT_REGEXP[$pat]")
    buf="$buf[$(($MEND+1)),-1]"
    OFFSET=$((MEND+OFFSET));
  done
}
