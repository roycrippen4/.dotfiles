#!/bin/bash

# Default values
DEBUG=0
RELAUNCH=0       # By default, relaunch is turned off
DIRECTORY=$(pwd) # Set default directory to current working directory

# Function to display help message
usage() {
  echo "Usage: $0 [-d] [-r] [-v] [-h] [path]"
  echo "  -d            Run in debug mode"
  echo "  -r            Enable re-launching of nvim upon exit"
  echo "  -v            Display version information and exit"
  echo "  -h            Display this help and exit"
  echo "  path          Specify a path to a file or directory (optional)"
}

# Process options
while getopts "dhrv" opt; do
  case $opt in
  d) DEBUG=1 ;;
  r) RELAUNCH=1 ;;
  v)
    nvim -v
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

if [ $RELAUNCH -eq 1 ]; then
  while true; do
    nvim "$DIRECTORY" # Quoted to handle paths with spaces

    if [ $? -ne 0 ]; then
      break
    fi

    echo 'restarting'
  done
else
  nvim "$DIRECTORY" # Quoted to handle paths with spaces
fi
