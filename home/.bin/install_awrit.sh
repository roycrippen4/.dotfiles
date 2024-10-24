#!/bin/bash

if command -v awrit &>/dev/null; then
  echo "awrit is already installed. Exiting..."
  exit 0
fi

if command -v pacman &>/dev/null; then
  echo "Arch Linux detected (pacman available)"
  echo "installing dependencies..."
  sudo pacman -S --noconfirm base-devel ninja cmake
elif command -v apt &>/dev/null; then
  echo "Ubuntu detected (apt available)"
  sudo apt install -y build-essential ninja-build cmake
else
  echo "No supported package manager found. Exiting..."
fi

if [ /tmp/awrit ]; then
  echo "Removing existing awrit directory..."
  rm -rf /tmp/awrit
fi

echo "Cloning awrit into /tmp"
cd /tmp
git clone git@github.com:chase/awrit.git
cd ./awrit

echo "Building..."
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -S . -B build
cmake --build build
echo "Build complete. Installing..."

cmake --install build --prefix ~/.local

echo "Installation complete."
