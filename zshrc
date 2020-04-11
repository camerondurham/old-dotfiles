#!/usr/bin/env zsh

export DOTFILES=~/dot

source ${DOTFILES}/zsh/suggestions.zsh
source ${DOTFILES}/zsh/highlight.zsh
source ${DOTFILES}/zlerc # terminal cursor keybindings
source ${DOTFILES}/env # tokens

export HISTFILE=~/.hist/zsh
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history

bindkey -e

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# move into directory by typing its name w/o `cd`
setopt  autocd autopushd


vim_prompt() {
  if [ ! -z $VIMRUNTIME ]; then
    echo ":%F{green}sh ";
  fi
}

# List directory contents on entry
fn_cd() {
  if [ $# -eq 1 ]; then cd $1 && ls;
    else cd && ls;
  fi
}

# to test new prompts, use:
#  print -P '%B%F{red}co%F{green}lo%F{blue}rs%f%b'
# for 0-255 xterm color scale reference:
#  https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg


# Add a custom alias for restarting sshd
sshdr() {
  if [[ $(uname -s) == 'Linux' ]]; then
    sudo systemctl restart ssh
  elif [[ $(uname -s) == 'Darwin' ]]; then
    sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
    sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
  fi
}


# A. Traver
myip() {
  local public="$(curl -s https://checkip.amazonaws.com)"
  local private

  if [[ $(uname -s) == 'Darwin' ]]; then
    private="$(ipconfig getifaddr en0)"
  elif [[ $(uname -s) == 'Linux' ]]; then
    private="$(hostname -I | awk '{print $1}')"
  else
    echo "Error: unknown operating system" >&2
    return 1
  fi

  echo "Public IP: ${public}"
  echo "Private IP: ${private}"
  return 0
}

# Set vi as the default editor
VISUAL="vim"
EDITOR="vim"
PAGER="less"

# Call the function to set the path, without adding new variables to the shell
# setpath

# Make a directory to store history for various consoles
mkdir -p ~/.hist

# Configure history file locations
export LESSHISTFILE=~/.hist/less

export INPUTRC=${DOTFILES}/inputrc
export HUB_CONFIG=${DOTFILES}/hub/config
export XDG_CONFIG_HOME=${DOTFILES}
export HOME=~
export PRACTICE_CPP_LEETCODE=~/projects/practice/cpp/leetcode
export CS350_DOCKER_PROJECT=~/projects/cs350/project-3-cdurham_lee344_cmake/xv6-public-master
export ITP439=~/projects/uscc-camerondurham
eval "$(hub alias -s)"

# Disable <C-q> & <C-s>
stty -ixon

# Export environment variables
# Enable support for GPG encryption of echo command
export GPG_TTY=$(tty)

# Configure environments that can be CD'd into at all times
export CDPATH=.:$HOME/Dropbox:$HOME:~/site:$HOME/projects:$HOME/dot:$HOME/Dropbox/notes

# Add my shitty little run script to the path despite it being brittle & lazy
export PATH="/Users/camerondurham/projects/cs350-docker/run.sh:$PATH"
# Add anaconda to path
export PATH="/usr/local/anaconda3/bin:$PATH"
# Add ruby to path
export PATH="/Users/camerondurham/.gem/ruby/2.6.0/bin:$PATH"
# Add rust to system path
export PATH="$HOME/.cargo/bin:$PATH"
# Add Rust completion engine RACER to path
RUST_SRC_PATH=/usr/local/src/rust/src
# Add LLVM first in path
export PATH="/usr/local/opt/llvm/bin:$PATH"

# To use the bundled libc++ please add the following LDFLAGS:
LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"

# Tell compilers how to find llvm
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

export GOPATH=~/go
export GNUPGHOME=~/.gpg



# Colorize man pages via termcap capabilities
# `https://linux.die.net/man/5/termcap`

# md : start bold-mode (bold & red)
export LESS_TERMCAP_md=$(printf "\x1b[1;31m")

# mh : start faded-mode
export LESS_TERMCAP_mh=$(printf "\x1b[2m")

# mb : start blinking-mode (blinking & yellow)
export LESS_TERMCAP_mb=$(printf "\x1b[5;33m")

# so : start standout-mode
export LESS_TERMCAP_so=$(printf "\x1b[7;44;33m")

# se : end standout-mode
export LESS_TERMCAP_se=$(printf "\x1b[0m")

# us : start italic-mode
export LESS_TERMCAP_us=$(printf "\x1b[1;3;32m")

# ue : end italic-mode
export LESS_TERMCAP_ue=$(printf "\x1b[0m")

# me : disable all modes (md, mb, mr, so, us)
export LESS_TERMCAP_me=$(printf "\x1b[0m")


# Colorize BSD ls
CLICOLOR=1
LSCOLORS='ExGxFxdxCxDxDxHBhDhCgC'

# Launch the GPG agent, unless one is already running
gpg-agent --daemon &>/dev/null

# Identifies the path of a UNIX-domain socket
# Used to communicate with the SSH agent
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# TODO:
# alias for starting CS350 docker image

# Colorize directory listings
ls() {
  if [[ $(uname -s) == 'Darwin' ]]; then
    if [[ -x /usr/local/opt/coreutils/libexec/gnubin/ls ]]; then
      /usr/local/opt/coreutils/libexec/gnubin/ls --color=auto "$@"
    else
      /bin/ls "$@"
    fi
  elif [[ $(uname -s) == 'Linux' ]]; then
    /bin/ls --color=auto "$@"
  else
    ls
  fi
}


site() {
  pushd ~/site
  bundle install --quiet
  bundle exec jekyll serve --quiet --open-url &
  popd
}


#  Toggle Vim session (or last suspended process) with Ctrl-Z

function fg-bg () {
	if [[ $BUFFER -eq 0 ]]; then
		fg
	else
		zle push-input
	fi
}

zle -N fg-bg
bindkey '^Z' fg-bg

# Create new notes in vim:
# zet a new note -> ~/Dropbox/notes/<TIMESTAMP>-a-new-note.md
zet() {
    nvim "+Zet $*"
}

# Edit new leetcode:
# lc 0982 some little problem -> ~/projects/practice/cpp/leetcode/0982_some_little_problem.cpp
lc() {
    nvim "+LC $*"
}

# Add dynamic git aliases shamelessly copied from thoughtbot

# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}


# Complete go like git
compdef g=git

# source aliases after function definitions
[ -f "${DOTFILES}/aliasrc" ] && source "${DOTFILES}/aliasrc" # aliases
export PATH="/usr/local/share/python/:$PATH"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
