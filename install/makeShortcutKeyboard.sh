#!/bin/sh

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

# Pegando lista dos atalhos personalizados
declare -a customKeybindings=($(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed -e "s/[][,]//g"))

msgShortcut="Sua tecla de atalho para abrir o gerenciador do docker: ${shortcutKeyboard}\n"

# Verificando se atalho personalizado do gerenciador do docker já existe
for i in ${!customKeybindings[@]}; do
    if [[ "$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${i}/ name)" = "'${shortcutName}'" ]]; then

	printf "Já existe um atalho para o gerenciador do docker\n"
	printf "${msgShortcut}"
        
        printf "\e[33m"
        printf "[OK]\n\n"
        printf "\e[39m"

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
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ name "${shortcutName}"

# Setando comando do novo atalho
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ command "${shortcutCommand}"

# Setando bind tecla do novo atalho
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newCustomIndex}/ binding "${shortcutKeyboard}"

# Pegando lista dos atalhos personalizados atualizado
declare -a customKeybindingsNews=($(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | sed -e "s/[][,]//g"))

# Flag de atalho inexistente
existsDockerShortcut="0"

# Verificando se atalho personalizado do gerenciador do docker já existe
for newI in ${!customKeybindingsNews[@]}; do
    if [[ "$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${newI}/ name)" = "'${shortcutName}'" ]]; then

	# Flag de atalho existente
	existsDockerShortcut="1"
	
	break

    fi
done

# Caso o atalho do gerenciador do docker já exista, exibe mensagem e para script
if [[ "${existsDockerShortcut}" = "0" ]]; then

    printf "Não foi possível criar o atalho do gerenciador do docker: ${shortcutName}\n"

    printf "\e[31m"
    printf "[NOK]\n\n"
    printf "\e[39m"

    exit
fi

# Exibe mensagem de que o atalho do gerenciado do docker foi criado com sucesso
printf "Atalho do gerenciador do docker criado com sucesso: ${shortcutName}\n"
printf "${msgShortcut}"

printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"
