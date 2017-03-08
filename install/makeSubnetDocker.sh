#!/bin/sh

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

newNetwork="docker-manager-network"

if [[ ! -z $(sudo docker network ls --filter name=${newNetwork} --quiet) ]]; then 

    printf "Já existe uma network criada para o docker\n"

    printf "Nome da network criada: ${newNetwork}\n"

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

read -p "Por favor digite a faixa de IP que irá disponibilizar para a nova network [${newNetwork}]: " faixaips

sudo docker network create --subnet=${faixaips} ${newNetwork}

if [[ -z $(sudo docker network ls --filter name=${newNetwork} --quiet) ]]; then 

    printf "Não foi possível criar a network: ${newNetwork}\n"

    printf "\e[31m"
    printf "[NOK]\n\n"
    printf "\e[39m"

    exit
fi

printf "Network para o docker criada com sucesso: ${newNetwork}\n"

printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"
