#!/bin/sh

declare installdir=`dirname $0`
declare rootdir="$(dirname "$installdir")"

if [[ ! -z $(systemctl status docker | grep "docker.service Loaded: not-found") ]]; then 
    dockerVersion=$(docker --version)

    printf "O Docker já está instalado na máquina atual\n"
    printf "${dockerVersion}\n"

    exit
fi

# Add Docker GPG key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Create a new source file under /etc/apt/sources.list.d/.
touch /etc/apt/sources.list.d/docker.list

# Add this line in the file and save the file.
cat <<EOT >> /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo debian-jessie main
EOT

# Because the docker repository requires HTTPS connection so we need to install apt-transport-https and ca-certificates package to make APT establish HTTPS connection with docker repository.
sudo apt-get install apt-transport-https ca-certificates

# Update local package index and install docker on Debian 8.
sudo apt-get update && sudo apt-get install docker-engine

# Start the docker service.
sudo systemctl start docker

# Enable docker auto-start when Debian Jessie is booted up.
sudo systemctl enable docker

# Check docker status.
systemctl status docker

# Verify Docker installation is working correctly with this command:
sudo docker run hello-world

# Check Docker version.
docker --version

printf "\e[32m"
printf "[OK]\n\n"
printf "\e[39m"
