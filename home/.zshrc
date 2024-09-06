HISTFILE=~/.histfile
SAVEHIST=999
HISTSIZE=1000
setopt HIST_EXPIRE_DUPS_FIRST

# setopt autocd
bindkey -v
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# p10k setup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Editor settings
export VISUAL=nvim
export EDITOR="$VISUAL"
export MANPAGER='nvim +Man!'

# emacs
export PATH="$HOME/.emacs.d/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export ZSH="$HOME/.dotfiles/home/.oh-my-zsh" # Path to oh-my-zsh

# bob exec/bob zsh completions
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fpath+=$HOME/.dotfiles/home/.zfunc/

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

. "$HOME/.cargo/env" # Cargo setup

export MANPATH="/usr/local/man:$MANPATH"
export NODE_PATH="which node"
export PATH="$PATH:$HOME/.local/bin"          # kitty
export PATH="$PATH:$HOME/Opt/julia-1.9.4/bin" # Julia
export PATH="$HOME/.bin/nvim.sh:$PATH"        # nvim script

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL10k_MODE="nerdfont-complete"

DISABLE_AUTO_TITLE="true"
ZLE_RPROMPT_INDENT=0
DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

plugins=(
  # zsh-vi-mode
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH"/oh-my-zsh.sh
alias nvim="$HOME/.dotfiles/home/.bin/nvim.sh"
alias vim="$HOME/.dotfiles/home/.bin/nvim.sh"

go_to_nvim_config() {
  c "$HOME/.dotfiles/nvim/.config/nvim/"
}

go_to_home_config() {
  c "$HOME/.dotfiles/home"
}

go_to_kitty_config() {
  c "$HOME/.dotfiles/kitty/.config/kitty"
}

go_to_neodev_config() {
  c "$HOME/.dotfiles/nvim/.config/nvim/dev"
}

go_to_hypr_config() {
  c "$HOME/.dotfiles/hypr/.config/hypr"
}

go_to_wofi_config() {
  c "$HOME/.dotfiles/wofi/.config/wofi"
}

go_to_waybar_config() {
  c "$HOME/.dotfiles/waybar/.config/waybar"
}

alias python="python3"
alias cc="cd .."
alias x="exit"
alias emacs="emacsclient -c -a 'emacs'"
alias claer="clear"
alias cl="clear"
alias dot='cd && cd .dotfiles'
alias fz="fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}' --multi --bind 'enter:become(nvim {+})'"
alias search_images="$HOME/.dotfiles/home/.bin/search_images.sh"
alias hacker="cmatrix -c"
alias l='ls -l'
alias la='ls -a'
alias lg='lazygit'
alias lla='ls -la'
alias path='echo "${PATH//:/\n}"'
alias ls='lsd'
alias lt='ls --tree'
alias mi="mvn clean install -DskipTests"
alias so="$HOME/.dotfiles/home/.bin/source.zsh"
alias sync="$HOME/.dotfiles/home/.bin/sync.sh"
alias hconf=go_to_home_config
alias hyconf=go_to_hypr_config
alias kconf=go_to_kitty_config
alias nconf=go_to_nvim_config
alias ndev=go_to_neodev_config
alias wconf=go_to_wofi_config
alias bconf=go_to_waybar_config

alias dcb="sudo docker compose build"
alias dcu="sudo docker compose up"
alias dcd="sudo docker compose down"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
eval "$(zoxide init zsh --cmd c)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/roy/.bun/_bun" ] && source "/home/roy/.bun/_bun"

# auto activate/deactivate python venv when cd into/out of a folder
python_venv() {
  MYVENV=./venv
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source ./venv/bin/activate >/dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate >/dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv

python_venv
