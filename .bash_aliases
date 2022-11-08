# simple aliases
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
alias less="less -R"
alias myip="curl ifconfig.me"

# make directory and immediately cd to it
mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}

gitinfo() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  local untracked_files="Untracked files:"
  local not_staged="Changes not staged for commit:"
  local staged="Changes to be committed:"
  local branch_is_ahead="Your branch is ahead of"

  if git status &>/dev/null; then
    local msg="("

    if [[ $git_status =~ $on_branch ]]; then
      local branch=${BASH_REMATCH[1]}
      msg+="${color_blue}${branch}${color_reset}"
    elif [[ $git_status =~ $on_commit ]]; then
      local commit=${BASH_REMATCH[1]}
      msg+="${color_blue}${commit}${color_reset}"
    fi

    if [[ $git_status =~ $branch_is_ahead ]]; then
      msg+="|${color_green}\u2191${color_reset}"
    fi

    msg+=")"

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
