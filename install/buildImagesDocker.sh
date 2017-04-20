#!/bin/sh

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

read -p "Que imagem deseja pesquisar no Docker Hub: " search

searched=( $(sudo docker search --limit ${filterLimit} ${filterStars} ${filterOfficial} ${filterTrunc} "${search}" | awk '{if(NR>1) print $1}') )

for i in "${!searched[@]}"; do

    echo ${searched[$i]}

done

#printf "\e[32m"
#printf "[OK]\n\n"
#printf "\e[39m"
