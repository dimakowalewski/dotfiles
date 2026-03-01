bindkey '^R' history-incremental-search-backward

eval "$(starship init zsh)"

cd ~/Projects

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
