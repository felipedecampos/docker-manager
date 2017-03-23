#!/bin/sh

sudo echo $SHELL

clear

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

read -p " Digite o nome do container que deseja criar: " newEnvironment

hasEnvironment=0

for environment in `ls $rootdir/environments/`;
do
    if [[ "${environment%.*}" = "${newEnvironment}" ]]; then

        hasEnvironment=1

        break

    fi
done

if [[ "${environment%.*}" = "${newEnvironment}" ]]; then

    printf " O container que você deseja criar já existe\n"

    printf "\e[33m"
    printf " [OK]\n\n"
    printf "\e[39m"

    exit

fi

# Load functions
source $rootdir/core/core.sh

showUsedIps

printf "\n"

showAvailablesIpsFromNetwork ${network}

printf "\n"

read -p " Digite o ip que deseja parametrizar no container: " environmentIp

printf "\n"

showImages

read -p " Digite o nome e a versão da imagem que deseja utilizar para criar o container (Ex. REPOSITORY:TAG): " imageName

read -p " Digite o volume que se encontra o projeto na máquina hospedeira (Ex. /var/www/projetoX): " environmentVol

read -p " Digite o volume onde deseja espelhar o projeto no docker (Ex. /var/www):" dockerVol



exit
#######################################################################################

if [[ ! -z $(sudo docker network ls --filter name=${network} --quiet) ]]; then 

    printf "Já existe uma network criada para o docker\n"

    printf "Nome da network criada: ${network}\n"

    printf "\e[33m"
    printf "[OK]\n\n"
    printf "\e[39m"

    exit
fi

networks=($(sudo docker network ls | grep -v -e "host" -e "none" | awk '{ if(NR>1) print $2 }'))

old="$IFS"
IFS="|"
str="${networks[*]}"
findNetworks="$str"
IFS=$old

foundNetworks=($(sudo docker network inspect --format="{{ range .IPAM.Config }}{{ .Subnet }}{{end}}" $(sudo docker network ls --filter name="${findNetworks}" -q)))

if [[ "${#foundNetworks[@]}" != "0" ]]; then 
    
    printf "Não utilize essas faixas de IPs, pois as mesmas já encontram sendo usadas:\n"

    for i in ${!foundNetworks[@]}; do

        printf "> ${foundNetworks[$i]}\n"

    done

    printf "\n"

fi

declare -i lastIndexIp="${#foundNetworks[@]}"

lastIndexIp=${lastIndexIp}-1

declare -i baseIp="$(echo ${foundNetworks[${lastIndexIp}]} | sed -e 's/\..*//g')"

baseIp=${baseIp}+1

exampleIp="${baseIp}.1.0.0/16"

printf "Exemplo de faixa de IP: ${exampleIp}\n\n"

read -p "Por favor digite a faixa de IP que irá disponibilizar para a nova network [${network}]: " faixaips

sudo docker network create --subnet=${faixaips} ${network}

if [[ -z $(sudo docker network ls --filter name=${network} --quiet) ]]; then 

    printf "Não foi possível criar a network: ${network}\n"

    printf "\e[31m"
    printf "[NOK]\n\n"
    printf "\e[39m"

    exit
fi

printf "Network para o docker criada com sucesso: ${network}\n"

printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"
