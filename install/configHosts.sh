#!/bin/sh

exit

declare installdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare rootdir="$(dirname "$installdir")"

printf "Configurando arquivo de hosts.."

printf "\e[32m"
printf " [OK]\n\n"
printf "\e[39m"

printf "\e[33m"
printf " [OK]\n\n"
printf "\e[39m"

printf "\e[31m"
printf " [NOK]\n\n"
printf "\e[39m"
