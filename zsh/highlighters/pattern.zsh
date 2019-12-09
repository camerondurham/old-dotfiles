# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# List of keyword and color pairs.
typeset -gA ZSH_HIGHLIGHT_PATTERNS

# Whether the pattern highlighter should be called or not.
_zsh_highlight_highlighter_pattern_predicate()
{
  _zsh_highlight_buffer_modified
}

# Pattern syntax highlighting function.
_zsh_highlight_highlighter_pattern_paint()
{
  setopt localoptions extendedglob
  local pattern
  for pattern in ${(k)ZSH_HIGHLIGHT_PATTERNS}; do
    _zsh_highlight_pattern_highlighter_loop "$BUFFER" "$pattern"
  done
}

_zsh_highlight_pattern_highlighter_loop()
{
  # This does *not* do its job syntactically, sorry.
  local buf="$1" pat="$2"
  local -a match mbegin mend
  local MATCH; integer MBEGIN MEND
  if [[ "$buf" == (#b)(*)(${~pat})* ]]; then
    region_highlight+=("$((mbegin[2] - 1)) $mend[2] $ZSH_HIGHLIGHT_PATTERNS[$pat]")
    "$0" "$match[1]" "$pat"; return $?
  fi
}
