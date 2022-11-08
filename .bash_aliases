# simple aliases
alias cp="cp -i"		# confirm before overwriting
alias df="df -h"		# human-readable sizes
alias free="free -m"		# show sizes in MB
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
alias less="less -R"		# color output
alias myip="curl ifconfig.me"
alias open="xdg-open"

# Add an "alert" alias for long running commands.
# usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# retry last command as root
# usage: plz
alias plz='sudo "$BASH" -c "$(history -p !!)"'
alias please='sudo "$BASH" -c "$(history -p !!)"'

# mkcd - make directory and immediately cd to it
# usage: mkcd <new_directory>
mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

