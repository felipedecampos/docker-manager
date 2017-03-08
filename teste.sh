#!/bin/sh

#'#!/usr/bin/env bash'

#sudo apt-get install at

## The exit status of the last command run is 
## saved automatically in the special variable $?.
## Therefore, testing if its value is 0, is testing
## whether the last command ran correctly.
#if [[ $? > 0 ]]
#then
#    echo "The command failed, exiting."
#    exit
#else
#    echo "The command ran succesfuly, continuing with script."
#fi

waiting()
{
    pid=$!
    spinstr=""

    printf "Loading "

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; 
    do
        if [[ "${spinstr}" = "....." ]]; then
	    spinstr=""
	    printf "\b\b\b\b\b     "
	fi

	spinstr="${spinstr}."

	printf "$spinstr\b\b"

        sleep 0.75
    done
}

printf "\n[ Iniciando processo de instalação ]\n\n"

sleep 2

sudo $(sudo apt-get update) & waiting

#result=$(bash -c 'sudo apt-get update')

printf "[ok]\n\n"

exit

#Add Docker GPG key.
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

#Create a new source file under /etc/apt/sources.list.d/.
sudo nano /etc/apt/sources.list.d/docker.list

#Add this line in the file and save the file.
deb https://apt.dockerproject.org/repo debian-jessie main

#Because the docker repository requires HTTPS connection so we need to install apt-transport-https and ca-certificates package to make APT establish HTTPS connection with docker repository.
sudo apt-get install apt-transport-https ca-certificates

#Update local package index and install docker on Debian 8.
sudo apt-get update && sudo apt-get install docker-engine

#Start the docker service.
sudo systemctl start docker

#Enable docker auto-start when Debian Jessie is booted up.
sudo systemctl enable docker

#Check docker status.
systemctl status docker

#Verify Docker installation is working correctly with this command:
sudo docker run hello-world

#Check Docker version.
docker --version

exit
