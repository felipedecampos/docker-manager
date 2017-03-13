#!/bin/sh

clear

declare installdir=`dirname $0`
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

exit

printf "> Construindo imagens dos containers.. \n"
bash $installdir/buildImagesDocker.sh
printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"

printf "> Configurando os IPs dos containers em hosts.. \n"
bash $installdir/configHosts.sh
printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"

printf "[ Processo de instalação finalizado ]\n\n"

#verde
#printf "\e[32m"
#amarelo
#printf "\e[33m"
# vermelho
#printf "\e[31m"
