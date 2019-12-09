# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[root]:=standout}

# Whether the root highlighter should be called or not.
_zsh_highlight_highlighter_root_predicate()
{
  _zsh_highlight_buffer_modified
}

# root highlighting function.
_zsh_highlight_highlighter_root_paint()
{
  if (( EUID == 0 )) { _zsh_highlight_add_highlight 0 $#BUFFER root }
}
