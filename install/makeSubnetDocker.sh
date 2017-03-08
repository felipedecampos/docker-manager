#!/bin/sh

exit

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

newSubnet="manager-docker-containers"

if [[ ! -z $(sudo docker network ls --filter name=${newSubnet} --quiet) ]]; then 
    printf "Já existe uma subnet criada para que o docker possa ser acessado\n"
    printf "Nome da subnet criada: ${newSubnet}\n"

    exit
fi

sudo docker network create --subnet=173.1.0.0/16 ${newSubnet}

sleep 2
