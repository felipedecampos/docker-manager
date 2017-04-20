#!/bin/bash

declare -g coredir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -g rootdir="$(dirname "$coredir")"

# Load functions
source $coredir/core.sh

main

exec bash
