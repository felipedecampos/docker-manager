#!/bin/sh

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

#printf "\e[32m"
#printf " [OK]\n\n"
#printf "\e[39m"
#
#printf "\e[33m"
#printf " [OK]\n\n"
#printf "\e[39m"
#
#printf "\e[31m"
#printf " [NOK]\n\n"
#printf "\e[39m"

imagesHeader=$( sudo docker images --format "table {{.Repository}}:{{.Tag}}" | awk '{if(NR<2) print $1}')
imagesCreated=($( sudo docker images --format "{{.Repository}}:{{.Tag}}" | sed 's/ /_/g'))

if [ ${#imagesCreated[@]} == 0 ]; then

    noImagesCreated="\n
        Não existem imagens criadas \n
    "

    echo -e ${noImagesCreated}

    return 1

fi

headerImagesCreated="\0
    # \n
    # Imagens criadas: \n
    # \n
"

echo -e ${headerImagesCreated}

printf " ${imagesHeader}\n\n"

for key in ${!imagesCreated[@]}; do

    echo " [$key] ${imagesCreated[$key]}"

done

