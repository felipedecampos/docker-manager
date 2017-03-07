#!/bin/bash

declare -g coredir=`dirname $0`
declare -g rootdir="$(dirname "$coredir")"

# Load functions
source $coredir/core.sh

main

exec bash
