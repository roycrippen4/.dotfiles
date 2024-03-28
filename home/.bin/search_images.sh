#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <search_directory> <output_file_path>"
	exit 1
fi

search_directory=$1
output_file_path=$2

# Create the output file if it doesn't exist
touch "$output_file_path"

# Search for .png and .jpg files in the specified directory and subdirectories
find "$search_directory" -type f \( -iname "*.png" -o -iname "*.jpg" \) |
	fzf --multi --preview='kitten icat --clear --transfer-mode=memory --stdin=no --place=256x256@20x1 {} > /dev/tty' |
	tee -a "$output_file_path"
