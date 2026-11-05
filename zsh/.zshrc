export EDITOR="vim"
export VISUAL="vim"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

_fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type d --hidden --follow --exclude .git . "$1" }

# Better history
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # commands starting with a space aren't saved
setopt SHARE_HISTORY          # history shared across tabs and splits
setopt INC_APPEND_HISTORY     # write immediately, not on exit

# Nicer navigation
setopt AUTO_CD                # type a folder name to cd into it
setopt AUTO_PUSHD             # cd keeps a directory stack (use `popd` to go back)
setopt PUSHD_IGNORE_DUPS

# Better tab completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # case-insensitive
zstyle ':completion:*' menu select                    # arrow-key menu

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'

alias cat='bat --paging=never'
alias md='glow -p'

alias fp="fzf --preview 'bat --color=always {}'"

alias ..='cd ..'
alias ...='cd ../..'
alias ld='lazydocker'
alias lg='lazygit'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph -20'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gst='git stash'
alias gstu='git stash -u'
alias gsta='git stash apply'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gp='git push'
alias gpf='git push --force'
alias gfp='git push --force'
alias reload='source ~/.zshrc'

# Set up fzf key bindings and fuzzy completion
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :50 {}'"

source <(fzf --zsh)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

cd ~/Projects
