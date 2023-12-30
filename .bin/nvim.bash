#!/bin/bash

# Set DEBUG based on the first argument passed; default is 0 (off)
DEBUG=0
DIRECTORY="$HOME/.dotfiles/nvim/.config/nvim"
RELAUNCH=0

# Function to display help message
usage() {
  echo "Usage: $0 [-d] [-a directory] [-h]"
  echo "  -d            Run in debug mode"
  echo "  -a directory  Specify a directory to open with nvim"
  echo "  -r            Enables automatic relaunching of nvim on :q. Use :cq to break the loop."
  echo "  -h            Display this help and exit"
}

while getopts "da:" opt; do
  case $opt in
  d) DEBUG=1 ;;
  a) DIRECTORY=$OPTARG ;;
  r) RELAUNCH=1 ;;
  h)
    usage
    exit 0
    ;;
  *)
    echo 'Usage: nvim.bash [-d] [-a directory]' >&2
    exit 1
    ;;
  esac
done

export DEBUG

if [ $RELAUNCH -eq 1 ]; then
  while true; do
    nvim $DIRECTORY

    # If nvim exits with a non-zero exit code, break the loop
    if [ $? -ne 0 ]; then
      break
    fi

    echo 'restarting'
  done
fi
