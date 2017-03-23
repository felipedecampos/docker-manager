#!/bin/sh

sudo echo $SHELL

clear

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

read -p "Digite o nome do container que deseja criar: " newEnvironment

if [[ -z ${newEnvironment} ]]; then

    printf "Não foi digitado nenhum nome para o container\n"

    exit

fi

hasEnvironment=0

for environment in `ls $rootdir/environments/`;
do
    if [[ "${environment%.*}" = "${newEnvironment}" ]]; then

        hasEnvironment=1

        break

    fi
done

if [[ "${environment%.*}" = "${newEnvironment}" ]]; then

    printf "O container que você deseja criar já existe\n"

    printf "\e[33m"
    printf "[OK]\n\n"
    printf "\e[39m"

    exit

fi

# Load functions
source $rootdir/core/core.sh

showUsedIps

printf "\n"

showAvailablesIpsFromNetwork ${network}

printf "\n"

read -p "Digite o ip que deseja parametrizar no container: " environmentIp

printf "\n"

showImages

read -p "Digite o nome e a versão da imagem que deseja utilizar para criar o container (Ex. REPOSITORY:TAG): " imageName

read -p "Digite o volume que se encontra o projeto na máquina hospedeira (Ex. /var/www/projetoX): " environmentVol

read -p "Digite o volume onde deseja espelhar o projeto no docker (Ex. /var/www): " dockerVol

touch $rootdir/environments/${newEnvironment}.sh
chmod 775 $rootdir/environments/${newEnvironment}.sh

echo "#!/usr/bin/env bash

declare environmentIp=\"${environmentIp}\"
declare imageName=\"${imageName}\"
declare environmentVol=\"${environmentVol}\"
declare dockerVol=\"${dockerVol}\"" >> $rootdir/environments/${newEnvironment}.sh

if [[ -z $(find $rootdir/environments/${newEnvironment}* -maxdepth 0) ]]; then

    printf "Não foi possível criar o container: ${newEnvironment}\n"

    printf "\e[31m"
    printf "[NOK]\n\n"
    printf "\e[39m"

    exit
fi

printf "Container criado com sucesso: ${newEnvironment}\n"

printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"