# ~/.zshrc

# vim keybindings
bindkey -v
bindkey '^R' history-incremental-search-backward

PS1='%F{blue}%B%~%b%f %F{green}❯%f '

alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias mv='mv -i'
