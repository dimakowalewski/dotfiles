export EDITOR="vim"
export VISUAL="vim"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

_fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type d --hidden --follow --exclude .git . "$1" }

WORDCHARS=''

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

alias fp="fzf --preview 'bat --color=always {}'"

alias ..='cd ..'
alias ...='cd ../..'
alias ld='lazydocker'
alias lg='lazygit'
alias gs='git status'
alias gsh='git show'
alias gd='git diff'
alias gl='git log --oneline --graph -20'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gst='git stash'
alias gstu='git stash -u'
alias gsta='git stash apply'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gr='git restore'
alias grs='git restore --staged'
alias grb='git rebase'
alias grbd='git rebase develop'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias gp='git push'
alias gpf='git push --force'
alias gfp='git push --force'
alias gi='git init'
alias grma='git remote add'
alias grmr='git remote remove'

alias reload='source ~/.zshrc'

md() {
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    glow -p -s dark "$@"
  else
    glow -p -s light "$@"
  fi
}

gdf() {
  git diff --name-only HEAD | fzf \
    --preview 'git diff --color=always HEAD -- {} | delta' \
    --preview-window=right:70% \
    --bind 'enter:execute($EDITOR {})'
}

notes() {
  pushd ~/notes >/dev/null || return

  local style=light out key file
  defaults read -g AppleInterfaceStyle &>/dev/null && style=dark

  while true; do
    out=$(find . -type f -name '*.md' | sed 's|^\./||' | sort -f |
      fzf --expect=ctrl-e \
          --layout=reverse \
          --preview "CLICOLOR_FORCE=1 glow -s $style -w \$FZF_PREVIEW_COLUMNS {}" \
          --preview-window=right:60%)

    key=$(sed -n 1p <<< "$out")
    file=$(sed -n 2p <<< "$out")
    [[ -z $file ]] && break

    if [[ $key == ctrl-e ]]; then
      vim "$file"
    else
      md "$file"
    fi
  done

  popd >/dev/null
}

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
