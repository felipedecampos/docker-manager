#!/bin/sh

main()
{
    showInstructions

    handleService
}

showHeader()
{
    header="\0
	# \n
	# Inicializador de ambientes Docker \n
	# \n
	# Para sair digite: quit ou Ctrl+C \n
	# \n
	\n
	Serviços: \n
    "

    echo -e ${header}
}

showInstructions() 
{
    showHeader

    declare -ga services=(
	[1]="Exibir Imagens criadas"
	[2]="Exibir ambientes rodando"
	[3]="Iniciar ambientes" 
	[4]="Parar ambientes rodando" 
    )

    instructions="\0
        # \n
        # Qual serviço deseja utilizar: \n
        # \n
    "

    for key in ${!services[@]}; do

        echo -e " $key- ${services[$key]}\n"

    done

    echo -e ${instructions}
}

setUpEnvironments()
{
    declare -ga runningEnvironments

    listRunningEnvironments=( $(sudo docker ps | awk '{if(NR>1) print $NF}') )

    declare -ga availableEnvironments

    cod=0

    for environment in `ls $rootdir/environments/`;
    do
	cod=${cod}+1

        for i in "${!listRunningEnvironments[@]}"; do

	    if [[ "${listRunningEnvironments[$i]}" = "${environment%.*}" ]]; then
		
		runningEnvironments[${cod}]=${listRunningEnvironments[$i]}

	        continue 2;

	    fi

	done

        availableEnvironments[${cod}]=`basename "${environment%.*}"`

    done

    if [ ! ${#availableEnvironments[@]} = 0 ]; then
	availableEnvironments[0]="Todos"
    fi

    printf "\n"
}

showRunningContainers()
{
    setUpEnvironments

    clear

    if [ ${#runningEnvironments[@]} == 0 ]; then

	noEnvironmentsRunning="\n
	    Não existem ambientes rodando \n
	"

	echo -e ${noEnvironmentsRunning}

        return 1

    fi

    environmentsRunning="\0
        # \n
	# Ambientes rodando: \n
	# \n
    "    

    echo -e ${environmentsRunning}

    for key in ${!runningEnvironments[@]}; do

        printf " $key- ${runningEnvironments[$key]}\n"

    done

    printf "\n"
}

initEnvironments()
{
    setUpEnvironments

    clear

    if [[ ${#availableEnvironments[@]} == 0 ]]; then
        noAvailableEnvironments=" \n
	    Não existem ambientes disponíveis \n
	"

        echo -e ${noAvailableEnvironments}

        return 1
    fi

    headerAvailableEnvironments="\0
        # \n
	# Ambientes disponíveis: \n
	# \n
	# Para sair digite: quit ou Ctrl+C \n
	# \n
    "

    echo -e ${headerAvailableEnvironments}

    for key in ${!availableEnvironments[@]}; do

        echo -e " $key- ${availableEnvironments[$key]}"

    done

    echo -e "\0"

    while read -p " Digite o número do ambiente que deseja iniciar: " inputEnvironment 
    do
	handleExitProgram ${inputEnvironment}

        if [[ -z ${inputEnvironment} ]]; then
            continue

        else
	    if [[ "${inputEnvironment}" = "0" ]]; then
	        initAll="1"

	    else
		initAll="0"

	    fi

	    environmentNumberNotFound="1"
            
	    for i in "${!availableEnvironments[@]}"; do

		if [[ "${i}" = "0" ]]; then
		    continue
		fi

	        if [ "$i" = "${inputEnvironment}" ] || [ "${initAll}" = "1" ]; then

		    environment=$(sudo docker ps -a -f name=${availableEnvironments[$i]} --quiet)

		    printf "\n Iniciando ambiente: ${availableEnvironments[$i]}.."

	            if [[ ! -z $environment ]]; then 
        	        
			printf "\n > Starting, please wait.."
			environmentStarted=$(sudo docker exec $(sudo docker start ${environment}) /etc/init.d/apache2 start 2> /dev/null)

		    else
			
			printf "\n > Runing, please wait.."
	                gnome-terminal -e "sh $rootdir/environments/${availableEnvironments[$i]}.sh" --geometry=1x1+3000+0 --hide-menubar

    		    fi

		    environmentNumberNotFound="0"

	        fi

	    done

	    printf "\n\n"
	    
	    if [[ "${environmentNumberNotFound}" = "0" ]]; then
		sleep 5

	    	break
	    fi

	    printf "\n Número do ambiente digitado não encontrado.\n\n"

	    continue

        fi

    done
}

stopEnvironments()
{
    setUpEnvironments

    clear

    if [[ ${#runningEnvironments[@]} == 0 ]]; then
        noRunningEnvironments=" \n
	    Não existem ambientes rodando \n
	"

        echo -e ${noRunningEnvironments}

        return 1
    fi

    headerRunningEnvironments="\0
        # \n
	# Ambientes rodando: \n
	# \n
	# Para sair digite: quit ou Ctrl+C \n
	# \n
    "

    echo -e ${headerRunningEnvironments}

    declare -a fullRunningEnvironments

    originalIndex=${!runningEnvironments[*]}
    
    for index in $originalIndex;
    do
        fullRunningEnvironments[$index]=${runningEnvironments[$index]}
    done

    if [ ! ${#fullRunningEnvironments[@]} = 0 ]; then
	fullRunningEnvironments[0]="Todos"
    fi

    for key in ${!fullRunningEnvironments[@]}; do

        echo -e " $key- ${fullRunningEnvironments[$key]}"

    done

    echo -e "\0"

    while read -p " Digite o número do ambiente que deseja parar: " inputEnvironment 
    do
	handleExitProgram ${inputEnvironment}

        if [[ -z ${inputEnvironment} ]]; then
            continue

        else
	    if [[ "${inputEnvironment}" = "0" ]]; then
	        initAll="1"

	    else
		initAll="0"

	    fi

	    environmentNumberNotFound="1"
            
	    for i in "${!fullRunningEnvironments[@]}"; do

		if [[ "${i}" = "0" ]]; then
		    continue
		fi

	        if [ "$i" = "${inputEnvironment}" ] || [ "${initAll}" = "1" ]; then

	            if [[ ! -z $(sudo docker ps -a -f name=${fullRunningEnvironments[$i]} --quiet) ]]; then 
			printf "\n Parando ambiente: ${fullRunningEnvironments[$i]}.."

        	        environmentStoped=$(sudo docker stop $( sudo docker ps -a -f name=${fullRunningEnvironments[$i]} --quiet ))

		        environmentNumberNotFound="0"

		        continue
    		   fi

	        fi

	    done

	    printf "\n"
	    
	    if [[ "${environmentNumberNotFound}" = "0" ]]; then
		printf "\n"

	    	break
	    fi

	    printf " Número do ambiente digitado não encontrado.\n\n"

	    continue

        fi

    done
}

showImages()
{
    imagesCreated=$( sudo docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" ) #--filter=reference="*:latest"

    clear

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

    for key in ${!imagesCreated[@]}; do
     
        echo "${imagesCreated[$key]}"

    done

    printf "\n"
}

handleExitProgram()
{
    if [[ -z $1 ]]; then

        return 1

    elif [[ $1 = "quit" ]]; then

        exit 0

    fi
}

handleService()
{
    while read -p " Digite o número do serviço que deseja utilizar: " inputService 
    do
	printf "\n"

	handleExitProgram ${inputService}

        if [[ -z ${inputService} ]]; then
            continue

        elif [ ${inputService} == 1 ]; then
            showImages

            break

	elif [ ${inputService} == 2 ]; then
            showRunningContainers

            break

	elif [ ${inputService} == 3 ]; then
            initEnvironments

            break

        elif [ ${inputService} == 4 ]; then
            stopEnvironments

            break

        else
            printf "\n Número do serviço digitado não encontrado. \n\n";
        fi
    done

    main
}
