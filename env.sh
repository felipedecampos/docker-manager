#!/bin/sh

# Directories
declare -g rootdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -g coredir=$rootdir/core
declare -g environmentsdir=$rootdir/environments
declare -g installdir=$rootdir/install

# Network
declare -g network="docker-manager-network"

# Shurtcut Manager Docker
declare -g shortcutKeyboard="F12"
declare -g shortcutName="docker-manager"
declare -g shortcutCommand="sh ${rootdir}/init.sh"

# buildImages filters
declare -g filterLimit=30
declare -g filterStars="--filter STARS=1"
declare -g filterOfficial="" #"--filter "is-official=true""
declare -g filterTrunc="--no-trunc"