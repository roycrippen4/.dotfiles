fish_config theme choose "Dracula Official"
set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Editor settings
set -gx VISUAL nvim
set -gx EDITOR $VISUAL
set -gx MANPAGER 'nvim +Man!'
set -gx NVM_DIR $HOME/.nvm
set -gx GOPATH $HOME/go
set -gx BUN_INSTALL $HOME/.bun
set -gx MANPATH $MANPATH /usr/local/man
set -gx NODE_PATH "which node"

set PATH $PATH ./node_modules/.bin             # node
set PATH $PATH $GOPATH/bin                     # go
set PATH $PATH $HOME/.emacs.d/bin              # emacs
set PATH $PATH $HOME/.local/share/bob/nvim-bin # nvim binary
set PATH $PATH $BUN_INSTALL/bin                # bun
set PATH $PATH $HOME/.local/bin                # kitty
set PATH $PATH $HOME/Opt/julia-1.9.4/bin       # Julia
set PATH $PATH $HOME/.bin                      # scripts
set PATH $PATH $HOME/.cargo/bin/               # cargo


alias nvim $HOME/.dotfiles/home/.bin/nvim.sh
alias vim $HOME/.dotfiles/home/.bin/nvim.sh

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

function go_to_nvim_config 
  c $HOME/.dotfiles/nvim/.config/nvim/
end

function go_to_home_config 
  c "$HOME/.dotfiles/home"
end

function go_to_kitty_config 
  c "$HOME/.dotfiles/kitty/.config/kitty"
end

function go_to_neodev_config 
  c "$HOME/.dotfiles/nvim/.config/nvim/dev"
end

function go_to_hypr_config 
  c "$HOME/.dotfiles/hypr/.config/hypr"
end

function go_to_wofi_config 
  c "$HOME/.dotfiles/wofi/.config/wofi"
end

function go_to_waybar_config 
  c "$HOME/.dotfiles/waybar/.config/waybar"
end

function go_to_fish_config
  c "$HOME/.config/fish" && vim
end

alias x "exit"
alias eixt "exit"
alias cb "cd .."
alias emacs "emacsclient -c -a 'emacs'"
alias claer "clear"
alias cl "clear"
alias dot 'cd && cd .dotfiles'
alias fz "fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}' --multi --bind 'enter:become(nvim {+})'"
alias search_images "$HOME/.dotfiles/home/.bin/search_images.sh"
alias hacker "cmatrix -c"
alias l 'ls -l'
alias la 'ls -a'
alias lg 'lazygit'
alias lla 'ls -la'
alias ls 'lsd'
alias lt 'ls --tree'
alias so "$HOME/.dotfiles/home/.bin/source.zsh"
alias sync "$HOME/.dotfiles/home/.bin/sync.sh"
alias hconf go_to_home_config
alias hyconf go_to_hypr_config
alias kconf go_to_kitty_config
alias nconf go_to_nvim_config
alias ndev go_to_neodev_config
alias wconf go_to_wofi_config
alias bconf go_to_waybar_config
alias fconf go_to_fish_config

set --universal nvm_default_version v21.6.2
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
# thefuck --alias fuck | source 
zoxide init --cmd c fish | source
