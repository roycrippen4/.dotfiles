if status is-interactive
    # Commands to run in interactive sessions can go here
end

# go
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin

# Editor settings
set -gx VISUAL nvim
set -gx EDITOR $VISUAL
set -gx MANPAGER 'nvim +Man!'
set -gx PATH $PATH $HOME/.emacs.d/bin # emacs

# bun
set -gx BUN_INSTALL $HOME/.bun
set -gx PATH $PATH $BUN_INSTALL/bin
[ -s $HOME/.bun/_bun ] && source $HOME/.bun/_bun

set -gx PATH $PATH $HOME/.local/share/bob/nvim-bin
set -gx NVM_DIR $HOME/.nvm # nvm stuff
set -gx PATH $PATH $HOME/.cargo/env # set cargo env 
set -gx MANPATH $MANPATH /usr/local/man
set -gx NODE_PATH which node
set -gx PATH $PATH $HOME/.local/bin          # asdf
set -gx PATH $PATH $HOME/Opt/julia-1.9.4/bin # julia
set -gx PATH $PATH $HOME/.bin/nvim.sh

function go_to_nvim_config 
  c $HOME/.dotfiles/nvim/.config/nvim/
end

function go_to_home_config
  c $HOME/.dotfiles/home
end

function go_to_kitty_config 
  c $HOME/.dotfiles/kitty/.config/kitty
end

function go_to_neodev_config
	c $HOME/.dotfiles/nvim/.config/nvim/dev
end

function go_to_hypr_config
	c $HOME/.dotfiles/hypr/.config/hypr
end

function go_to_wofi_config
	c $HOME/.dotfiles/wofi/.config/wofi
end

function go_to_waybar_config
	c $HOME/.dotfiles/waybar/.config/waybar
end

alias bconf go_to_waybar_config
alias cb "cd .."
alias cl "clear"
alias claer "clear"
alias dot 'cd && cd .dotfiles'
alias emacs "emacsclient -c -a 'emacs'"
alias fz "fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}' --multi --bind 'enter:become(nvim {+})'"
alias hacker "cmatrix -c"
alias hconf go_to_home_config
alias hyconf go_to_hypr_config
alias kconf go_to_kitty_config
alias l 'ls -l'
alias la 'ls -a'
alias lg 'lazygit'
alias lla 'ls -la'
alias ls 'lsd'
alias lt 'ls --tree'
alias nconf go_to_nvim_config
alias ndev go_to_neodev_config
alias search_images "$HOME/.dotfiles/home/.bin/search_images.sh"
alias so "$HOME/.dotfiles/home/.bin/source.zsh"
alias sync "$HOME/.dotfiles/home/.bin/sync.sh"
alias nvim "$HOME/.dotfiles/home/.bin/nvim.sh"
alias vim "$HOME/.dotfiles/home/.bin/nvim.sh"
alias wconf go_to_wofi_config


[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
zoxide init --cmd c fish | source
