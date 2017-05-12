#!/bin/sh

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

searchImages()
{
    printf "\n"

    read -p " Que imagem deseja pesquisar no Docker Hub: " search

    printf "\n"

    searched=( $(sudo docker search --limit ${filterLimit} ${filterStars} ${filterOfficial} ${filterTrunc} "${search}" | awk '{if(NR>1) print $1}') )

    for i in "${!searched[@]}"; do

        echo -e " [${i}] ${searched[$i]}"

    done

    printf "\n Digite 'search' para pesquisar novamente as imagens \n\n"

    while read -p " Digite o número da imagem que deseja criar no docker: " imageNumber
    do
        if [[ -z ${imageNumber} ]]; then

            continue

        elif [[ "${imageNumber}" == "search" ]]; then

            searchImages

        else

            declare foundSearched="0"

            for i in "${!searched[@]}"; do

                if [[ "${i}" == "${imageNumber}" ]]; then

                    foundSearched="1"

                    break

                fi

            done

            if [[ "${foundSearched}" == "0" ]]; then

                printf "\n Número da imagem não localizada. \n\n";

                continue

            else

                printf "\n"

                while read -p " Você escolheu a imagem: ${searched[$imageNumber]}, deseja criar a imagem no docker [y/n]? " confirm
                do
                    if [[ "${confirm}" == "y" ]]; then

                        printf "\n Criando a imagem: ${searched[$imageNumber]}..\n\n"

                        declare resultBuild=$(sudo docker pull ${searched[$imageNumber]} | grep "Status: Downloaded newer image for")

                        if [[ -z ${resultBuild} ]]; then

                            printf " Não foi possível criar a imagem: ${searched[$imageNumber]}\n"

                            printf "\e[31m"
                            printf " [NOK]\n\n"
                            printf "\e[39m"

                        else

                            printf " Imagem: ${searched[$imageNumber]}, criada com sucesso!\n"

                            printf "\e[32m"
                            printf " [OK]\n\n"
                            printf "\e[39m"

                        fi

                        break

                    elif [[ "${confirm}" == "n" ]]; then

                        searchImages

                    fi
                done

                break 2

            fi

        fi

        searchImages

    done
}

searchImages