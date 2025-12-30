# ~/.zshrc

# vim keybindings
bindkey -v
bindkey '^R' history-incremental-search-backward

PS1='%F{blue}%B%~%b%f %F{green}❯%f '

# ls colors
# 11 pairs of foreground background pairs
export LSCOLORS=ExGxcxdxBxegedabagacad
alias ls='ls --color=auto -hv'

alias grep='grep --color=auto'
alias mv='mv -i'
