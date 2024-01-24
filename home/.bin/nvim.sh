#!/bin/sh

# Default values
DEBUG=0
RELAUNCH=0       # By default, relaunch is turned off
DIRECTORY=$(pwd) # Set default directory to current working directory
VIM_CMD=""       # Empty by default

# Function to display help message
usage() {
  echo "Usage: $0 [-c] [-d] [-D] [-r] [-v] [-h] [path]"
  echo "  -c cmd        Launch Neovim and execute a vimscript command"
  echo "  -d            Run in debug mode"
  echo "  -D            Run in diff mode"
  echo "  -r            Enable re-launching of nvim upon exit"
  echo "  -u            Launch Neovim without loading config"
  echo "  -v            Display version information and exit"
  echo "  -h            Display this help and exit"
  echo "  path          Specify a path to a file or directory (optional)"
}

# Process options
while getopts "dDhurvc" opt; do
  case $opt in
  D) nvim -d ;;
  d) DEBUG=1 ;;
  r) RELAUNCH=1 ;;
  v)
    nvim -v
    exit 0
    ;;
  u)
    nvim -u NONE -U NONE
    exit 0
    ;;
  h)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 1
    ;;
  esac
done

# Shift off all the options that were processed
shift $((OPTIND - 1))

# If there's an additional argument, treat it as the directory or file path
if [ "$1" ]; then
  DIRECTORY=$1
fi

export DEBUG

nvim_cmd() {
  if [ -n "$VIM_CMD" ]; then
    nvim "$DIRECTORY" -c "$VIM_CMD"
  else
    nvim "$DIRECTORY"
  fi
}

if [ $RELAUNCH -eq 1 ]; then
  while true; do
    nvim_cmd

    if [ $? -ne 0 ]; then
      break
    fi

    echo 'restarting'
  done
else
  nvim_cmd
fi
