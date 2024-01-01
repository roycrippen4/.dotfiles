#!/bin/zsh

BLUE='\033[1;34m'
RED='\033[1;30m'
GREEN='\033[1;32m'

echo "${BLUE} Navigating to .zshrc..."
cd_result=$(cd && cd "$HOME/.dotfiles/home/")

if [ $? -ne 0 ]; then
  echo "${RED}Error: Failed to navigate to .zshrc directory. (Exit Code: $?)"
fi

echo "${BLUE} Sourcing .zshrc..."
source .zshrc

source_exit_code=$?
if [ $source_exit_code -ne 0 ]; then
  echo "${RED}ERROR: Failed to source .zshrc (Exit Code: $source_exit_code)."
  exit 1
fi

echo "${GREEN} Sourced .zshrc"
