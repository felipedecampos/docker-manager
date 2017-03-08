#!/bin/sh

exit

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

# Pegando lista dos atalhos personalizados
declare -a customKeybindings=($(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed -e "s/[][,]//g"))

msgShortcut="Sua tecla de atalho para abrir o gerenciador de containers do docker: F12\n"

for i in ${!customKeybindings[@]}; do
    if [[ "$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${i}/ name)" = "'manager-docker-containers'" ]]; then

	printf "Já existe um atalho para o gerenciador de containers do docker\n"
	printf "${msgShortcut}"

	exit

    fi
done

newCustomIndex=${#customKeybindings[@]}

# Montando nova lista dos atalhos personalizados
customKeybindings[${newCustomIndex}]="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/'"

old="$IFS"
IFS=","
str="${customKeybindings[*]}"
newList="$str"
IFS=$old

# Setando nova lista dos atalhos personalizados
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[${newList}]"

# Setando nome do novo atalho
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ name 'manager-docker-containers'

# Setando comando do novo atalho
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ command "sh ${rootdir}/init.sh"

# Setando bind tecla do novo atalho
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ binding "F12"

printf echo -e "${msgShortcut}"
