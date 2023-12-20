# shellcheck disable=2155
export SHELL=$(which zsh)
[ -z "$ZSH_VERSION" ] && exec "$SHELL" -l
