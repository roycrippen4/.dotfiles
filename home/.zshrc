# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC1094
#
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# setopt autocd
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

# bob exec/bob zsh completions
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fpath+=$HOME/.dotfiles/home/.zfunc/

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
# kitty
export PATH="$PATH:$HOME/.local/bin"
# Julia
export PATH="$PATH:$HOME/Opt/julia-1.9.4/bin"

export PATH="$HOME/.bin/nvim.sh:$PATH"

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

source "$ZSH"/oh-my-zsh.sh
alias nvim="$HOME/.dotfiles/home/.bin/nvim.sh"
alias vim="$HOME/.dotfiles/home/.bin/nvim.sh"

go_to_nvim_config() {
  cd "$HOME/.dotfiles/nvim/.config/nvim/"
}

go_to_home_config() {
  cd "$HOME/.dotfiles/home"
}

go_to_kitty_config() {
  cd "$HOME/.dotfiles/kitty/.config/kitty"
}

go_to_neodev_config() {
  cd "$HOME/.dotfiles/nvim/.config/nvim/dev"
}

alias nconf=go_to_nvim_config
alias hconf=go_to_home_config
alias kconf=go_to_kitty_config
alias ndev=go_to_neodev_config
alias lg='lazygit'
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lp='echo "${PATH//:/\n}"'
alias dot='cd && cd .dotfiles'
alias so="$HOME/.dotfiles/home/.bin/source.zsh"
alias sync="$HOME/.dotfiles/home/.bin/sync.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
