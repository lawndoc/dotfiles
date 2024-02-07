# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set color term if it exists
export TERM=xterm-256color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

color_red="\033[0;31m"
color_yellow="\033[0;33m"
color_green="\033[0;32m"
color_ochre="\033[38;5;95m"
color_blue="\033[0;36m"
color_white="\033[0;37m"
color_reset="\033[0m"

# gitinfo - gather git tracking info for prompt
# usage: gitinfo
git_info() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  local untracked_files="Untracked files:"
  local not_staged="Changes not staged for commit:"
  local staged="Changes to be committed:"
  local branch_is_ahead="Your branch is ahead of"

  if git status &>/dev/null; then
    local msg="${color_green}("

    if [[ $git_status =~ $on_branch ]]; then
      local branch=${BASH_REMATCH[1]}
      msg+="${color_yellow}${branch}${color_reset}"
    elif [[ $git_status =~ $on_commit ]]; then
      local commit=${BASH_REMATCH[1]}
      msg+="${color_yellow}${commit}${color_reset}"
    fi

    if [[ $git_status =~ $branch_is_ahead ]]; then
      msg+="|${color_yellow}\u2191${color_reset}"
    fi

    msg+="${color_green})"

    if [[ $git_status =~ $untracked_files
      || $git_status =~ $not_staged 
      || $git_status =~ $staged ]]; then
    
      msg+=" "

      if [[ $git_status =~ $untracked_files ]]; then
        msg+="${color_red}\u271A${color_reset}"
      fi

      if [[ $git_status =~ $not_staged ]]; then
        msg+="${color_yellow}\u271A${color_reset}"
      fi

      if [[ $git_status =~ $staged ]]; then
        msg+=" ${color_green}\u25CF${color_reset}"
      fi

      msg+=" "
    fi
    echo -e "$msg"
  fi
}

# Set prompt
if [ "$color_prompt" = yes ]; then
  # user
  if [ "$EUID" == 0 ]; then
    PS1="\[${color_green}\]┌──(\[${color_red}\]\u\[${color_reset}\]"
  else
    PS1="\[${color_green}\]┌──(\[${color_blue}\]\u\[${color_reset}\]"
  fi
  # @ host
  PS1+="@\[${color_blue}\]\h\[${color_green}\])"
  # Current working directory
  PS1+="-[\[${color_reset}\]\w\[${color_green}\]]"
  # (git_branch)
  PS1+=" \$(git_info)"
  # newline
  PS1+="\n\[${color_green}\]└─\[${color_reset}\]"
  # '#' for root otherwise '$'
  if [ "$EUID" == 0 ]; then
    PS1+="\[${color_red}\]\# \[${color_reset}\]"
  else
    PS1+="\[${color_blue}\]\$ \[${color_reset}\]"
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add CUDA to path if it is installed
if [ -f /usr/local/cuda/bin/nvcc ]; then
  export PATH=/usr/local/cuda/bin:$PATH
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
fi

# Powerline
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bindings/bash/powerline.sh
fi

# Change editor to NVim
if [ -f /usr/local/bin/nvim ]; then
  export EDITOR=nvim
  alias vim=nvim
elif [ -f /usr//bin/nvim ]; then
  export EDITOR=nvim
  alias vim=nvim
elif [ -f /usr/bin/vim ]; then
  export EDITOR=vim
fi

# WSL2 KeePassXC ssh-agent sync
# requires socat and OpenSSH-Win32 >= 8.9.1.0
uname -r | grep WSL2 > /dev/null
if [ $? == 0 ]; then
  ${HOME}/.local/bin/wsl-ssh-agent-sync start
  export SSH_AUTH_SOCK=${HOME}/.ssh/wsl-ssh-agent.sock
fi

# NVM
if [ -f ~/.nvm/nvm.sh ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH:/usr/local/go/bin"
