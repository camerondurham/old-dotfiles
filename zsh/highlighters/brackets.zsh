# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[bracket-error]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-1]:=fg=blue,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-2]:=fg=green,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-3]:=fg=magenta,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-4]:=fg=yellow,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-5]:=fg=cyan,bold}
: ${ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]:=standout}

# Whether the brackets highlighter should be called or not.
_zsh_highlight_highlighter_brackets_predicate()
{
  [[ $WIDGET == zle-line-finish ]] || _zsh_highlight_cursor_moved || _zsh_highlight_buffer_modified
}

# Brackets highlighting function.
_zsh_highlight_highlighter_brackets_paint()
{
  local char style
  local -i bracket_color_size=${#ZSH_HIGHLIGHT_STYLES[(I)bracket-level-*]} buflen=${#BUFFER} level=0 matchingpos pos
  local -A levelpos lastoflevel matching

  # Find all brackets and remember which one is matching
  for (( pos = 1; pos <= buflen; pos++ )) ; do
    char=$BUFFER[pos]
    case $char in
      ["([{"])
        levelpos[$pos]=$((++level))
        lastoflevel[$level]=$pos
        ;;
      [")]}"])
        if (( level > 0 )); then
          matchingpos=$lastoflevel[$level]
          levelpos[$pos]=$((level--))
          if _zsh_highlight_brackets_match $matchingpos $pos; then
            matching[$matchingpos]=$pos
            matching[$pos]=$matchingpos
          fi
        else
          levelpos[$pos]=-1
        fi
        ;;
    esac
  done

  # Now highlight all found brackets
  for pos in ${(k)levelpos}; do
    if (( $+matching[$pos] )); then
      if (( bracket_color_size )); then
        _zsh_highlight_add_highlight $((pos - 1)) $pos bracket-level-$(( (levelpos[$pos] - 1) % bracket_color_size + 1 ))
      fi
    else
      _zsh_highlight_add_highlight $((pos - 1)) $pos bracket-error
    fi
  done

  # If cursor is on a bracket, then highlight corresponding bracket, if any.
  if [[ $WIDGET != zle-line-finish ]]; then
    pos=$((CURSOR + 1))
    if (( $+levelpos[$pos] )) && (( $+matching[$pos] )); then
      local -i otherpos=$matching[$pos]
      _zsh_highlight_add_highlight $((otherpos - 1)) $otherpos cursor-matchingbracket
    fi
  fi
}

# Helper function to differentiate type
_zsh_highlight_brackets_match()
{
  case $BUFFER[$1] in
    \() [[ $BUFFER[$2] == \) ]];;
    \[) [[ $BUFFER[$2] == \] ]];;
    \{) [[ $BUFFER[$2] == \} ]];;
    *) false;;
  esac
}
