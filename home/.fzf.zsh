# Setup fzf
# ---------
if [[ ! "$PATH" == */home/roy/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/roy/.fzf/bin"
fi

source <(fzf --zsh)

# Auto-completion
# ---------------
# source "/home/roy/.fzf/shell/completion.zsh"

# Key bindings
# ------------
# source "/home/roy/.fzf/shell/key-bindings.zsh"
