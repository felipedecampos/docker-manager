#!/bin/sh

clear

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

sudo ls 1> /dev/null

printf "\n[ Processo de instalação iniciado ] \n\n"
sleep 1

printf "> Instalando docker.. \n"
#bash $installdir/installDocker.sh

printf "> Criando network onde o docker será acessado..\n"
#bash $installdir/makeSubnetDocker.sh

printf "> Criando atalho do gerenciador do docker.. \n"
#bash $installdir/makeShortcutKeyboard.sh

printf "> Construindo imagens do docker.. \n"
#bash $installdir/buildImagesDocker.sh

printf "> Criando arquivos de ambientes.. \n"
#bash $installdir/makeEnvironmentDocker.sh

printf "> Criando container baseado nas imagens e arquivos de ambientes.. \n"
#bash $installdir/runContainerDocker.sh

printf "> Configurando os IPs dos containers em hosts.. \n"
bash $installdir/configHosts.sh

exit

printf "[ Processo de instalação finalizado ]\n\n"
