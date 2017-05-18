#!/bin/sh

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

# Load config
source $rootdir/env.sh

runContainer()
{
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

    printf "\n"

    while read -p " Digite o número da imagem que utilizar para criar o container: " imageNumber
    do
        if [[ -z ${imageNumber} ]]; then

            continue

        else

            declare foundImageNumber="0"

            for i in "${!imagesCreated[@]}"; do

                if [[ "${i}" == "${imageNumber}" ]]; then

                    foundImageNumber="1"

                    break

                fi

            done

            if [[ "${foundImageNumber}" == "0" ]]; then

                printf "\n Número da imagem não localizada. \n\n";

                continue

            else

                printf "\n"

                while read -p " Você escolheu a imagem: ${imagesCreated[$imageNumber]}, deseja criar o container no docker [y/n]? " confirm
                do
                    if [[ "${confirm}" == "y" ]]; then

                        printf "\n"

                        while read -p " Digite o nome que deseja utilizar no container: " containerName
                        do
                            existsEnvironment=$(sudo docker ps -a -f name=${containerName} --quiet)

                            if [[ -z ${containerName} ]]; then

                                continue

                            elif [[ ! -z ${existsEnvironment} ]]; then

                                printf "\n Este nome de container: '${containerName}', já está sendo usado, por favor, utilize um novo\n\n"

                                continue

                            else

                                break

                            fi
                        done

                        printf "\n"

                        read -p " Digite a TAG que deseja utilizar no container: " containerTag

                        printf "\n"

                        declare -a environments
                        cod=1

                        for environment in `ls $rootdir/environments/`;
                        do
                            if [[ "${environment%.*}" = "sample" ]]; then

                                continue
                            fi

                            environments[${cod}]="${environment%.*}"

                            cod=${cod}+1
                        done

                        if [[ ${#environments[@]} == 0 ]]; then
                            noAvailableEnvironments=" \n
                                Não existem arquivos de ambientes \n
                            "

                            echo -e ${noAvailableEnvironments}

                            break
                        fi

                        headerAvailableEnvironments="\0
                            # \n
                            # Arquivos de ambientes: \n
                            # \n
                        "

                        echo -e ${headerAvailableEnvironments}

                        for key in ${!environments[@]}; do

                            echo -e " [$key] ${environments[$key]}"

                        done

                        echo -e "\0"

                        read -p " Digite o número do ambiente que deseja iniciar: " inputEnvironment

                        printf "\n Criando container: ${containerName}..\n\n"

                        source $environmentsdir/"${environments[$inputEnvironment]}.sh"

                        declare resultRunContainer=$(sudo docker run -ti --detach --network ${network} --ip ${environmentIp} --name ${environments[$inputEnvironment]} -v ${environmentVol}:${dockerVol} ${imagesCreated[$imageNumber]} 2> /dev/null)

                        runnedEnvironment=$(sudo docker ps -a -f name=${environments[$inputEnvironment]} --quiet)

                        if [[ -z ${runnedEnvironment} ]]; then

                            printf " Não foi possível criar o container: ${containerName}\n"

                            printf "\e[31m"
                            printf " [NOK]\n\n"
                            printf "\e[39m"

                        else

                            printf " Container: ${containerName}, criado com sucesso!\n"

                            printf "\e[32m"
                            printf " [OK]\n\n"
                            printf "\e[39m"

                        fi

                        break

                    elif [[ "${confirm}" == "n" ]]; then

                        runContainer

                    fi
                done

                break 2

            fi

        fi

    done
}

runContainer