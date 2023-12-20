# shellcheck disable=2155
export PATH="$HOME/.local/bin:$PATH"
export SHELL=$(which zsh)
[ -z "$ZSH_VERSION" ] && exec "$SHELL" -l
