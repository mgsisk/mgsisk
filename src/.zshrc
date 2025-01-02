#!/bin/zsh

autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' check-for-staged-changes true
zstyle ':vcs_info:*' formats '%B%u%c%m%F{cyan}%s%F{white}:%F{blue}%b%F{white}:%F{magenta}%r%F{black}/%S%%b'
zstyle ':vcs_info:*' actionformats '%B%F{black}%a %F{cyan}%s%F{white}:%F{blue}%b%F{white}:%F{magenta}%r%F{black}/%S%%b'
zstyle ':vcs_info:*' nvcsformats '%B%F{black}%~%f%b'
zstyle ':vcs_info:*' stagedstr '%F{green}• '
zstyle ':vcs_info:*' unstagedstr '%F{yellow}* '
zstyle ':vcs_info:git*+set-message:*' hooks git-messages

add-zsh-hook precmd vcs_info

+vi-git-messages() {
  if git status --porcelain | grep -q '^?' # untracked-changes
    then hook_com[unstaged]="%F{red}× ${hook_com[unstaged]}"
  fi

  if git stash list | grep -qc '' # stashed
    then hook_com[misc]="%F{black}⊡ ${hook_com[misc]}"
  fi
}

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt PROMPT_SUBST

PS1='%B%(!.%(?.#.%F{red}×).%(?.❯.%F{red}×))%f%b '
PS2='%F{black}•%f '
RPS1='${vcs_info_msg_0_}'
RPS2='%B%F{black}%^%f%b'

alias ls='ls -FGhl'
alias run='npm run -s'
alias update='mas upgrade && brew update && brew outdated && brew upgrade && brew cleanup'
