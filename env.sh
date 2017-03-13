#!/bin/sh

# Directories
declare -g rootdir=/home/$USER/projects/docker-manager
declare -g coredir=$rootdir/core
declare -g environmentsdir=$rootdir/environments
declare -g installdir=$rootdir/install

# Network
declare -g network="docker-manager-network"

# Shurtcut Manager Docker
declare -g shortcutKeyboard="F12"
declare -g shortcutName="manager-docker"
declare -g shortcutCommand="sh ${rootdir}/init.sh"

