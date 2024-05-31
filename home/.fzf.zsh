# Setup fzf
# ---------
if [[ ! "$PATH" == */home/roy/.local/share/nvim/lazy/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/roy/.local/share/nvim/lazy/fzf/bin"
fi

source <(fzf --zsh)
