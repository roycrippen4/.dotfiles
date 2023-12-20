# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC1094
#
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd
bindkey -v
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
fi

# Editor settings
export VISUAL=nvim
export EDITOR="$VISUAL"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.dotfiles/home/.oh-my-zsh"

# NVM stuff
export NVM_DIR="$HOME/.nvm"
# shellcheck source=../../.nvm/nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# shellcheck source=../../.nvm/bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
. "$HOME/.cargo/env"

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
# export NVM_DIR='~/.nvm/'
export NODE_PATH="which node"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL10k_MODE="nerdfont-complete"

DISABLE_AUTO_TITLE="true"
ZLE_RPROMPT_INDENT=0
DISABLE_UNTRACKED_FILES_DIRTY="true"
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

plugins=(
  zsh-vi-mode
  git
  zsh-autosuggestions
  fzf
  zsh-syntax-highlighting
)

# shellcheck source=../../.dotfiles/home/.oh-my-zsh/oh-my-zsh.sh
source "$ZSH"/oh-my-zsh.sh
alias vim="nvim"

go_to_nvim_config() {
  cd "$HOME/.dotfiles/nvim/.config/nvim" && vim .
}

nvims() {
  items=$(find "$HOME"/.config -maxdepth 2 -name "init.lua" -type f -execdir sh -c 'pwd | xargs basename' \;)
  selected=$(printf "%s\n" "${items[@]}" | FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS-} --preview-window 'right:border-left:50%:<40(right:border-left:50%:hidden)' --preview 'lsd -l -A --tree --depth=1 --color=always --blocks=size,name ~/.config/{} | head -200'" fzf)
  if [[ -z $selected ]]; then
    return 0
  elif [[ $selected == "nvim" ]]; then
    selected=""
  fi
  NVIM_APPNAME=$selected nvim "$@"
}

alias nvs=nvims
alias nvim-chad="NVIM_APPNAME=nvchad nvim"
alias config=go_to_nvim_config
alias ls="lsd"
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lp='echo "${PATH//:/\n}"'
alias dot='.dotfiles'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
