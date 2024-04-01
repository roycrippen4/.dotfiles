#!/bin/bash

directory=~/.dotfiles/waybar/.config/waybar/wallpapers/
monitor_top=DP-1
monitor_bot=DP-2

if [ -d "$directory" ]; then
	random_background=$(ls $directory/*.{jpg,png} | shuf -n 1)

	hyprctl hyprpaper unload all
	hyprctl hyprpaper preload $random_background
	hyprctl hyprpaper wallpaper "$monitor_bot, $random_background"
	hyprctl hyprpaper wallpaper "$monitor_top, $random_background"
fi
