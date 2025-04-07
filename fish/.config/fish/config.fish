set fish_greeting
set -gx ZVM_SET_CU

if test -f $HOME/.fishenv
    source $HOME/.fishenv
end

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

if status is-interactive
    fish_add_path $HOME/.bun/bin
    fish_add_path $HOME/.local/share/bob/nvim-bin/
    fish_add_path $HOME/.local/bin
    fish_add_path /usr/local/man/

    function nvm_use_on_dir --on-variable PWD
        if test -e ./.nvmrc
            set nvm_version (cat .nvmrc)
            if not nvm list | grep -q $nvm_version
                echo "Required Node version $nvm_version not found, installing..."
                nvm install $nvm_version
            end
            nvm use
        else
            nvm -s use system
        end
    end

    set -g fish_key_bindings fish_hybrid_key_bindings
end

function ls
    command lsd $argv
end

function l
    command lsd -l $argv
end

function la
    command lsd -a $argv
end

function lt
    command lsd --tree
end

function path
    echo $PATH\n
end

function nvim
    $HOME/.dotfiles/home/.bin/vim-cli $argv
end

function vim
    $HOME/.dotfiles/home/.bin/vim-cli $argv
end

function bp
    command nvim $HOME/.config/fish/config.fish
end

function x
    exit
end

function claer
    clear
end

function nconf
    cd $HOME/.config/nvim/
end

function kconf
    cd $HOME/.config/kitty/
end

function gconf
    cd $HOME/.config/ghostty/
end

function hyconf
    cd $HOME/.config/hypr/
end

function fconf
    cd $HOME/.config/fish/
end

function dot
    cd $HOME/.dotfiles
end

function lg
    command lazygit
end

function attach
    command zellij attach (zellij ls -s | fzf)
end

function sync
    $HOME/.dotfiles/home/.bin/sync.sh
end

starship init fish | source
zoxide init --cmd c fish | source
fzf --fish | source

test -r "$HOME/.opam/opam-init/init.fish" && source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>/dev/null; or true

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
