#!/bin/sh

list=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[<altered_list>]"

declare -i index=(${#list[@]})+1

#1: gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
#2: substituir array com novo nó
#3: gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name '<newname>'
#4: gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command '<newcommand>'
#5: gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<key_combination>'
