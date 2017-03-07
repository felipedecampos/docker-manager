#!/bin/bash

coredir=`dirname $0`

gnome-terminal -e "bash $coredir/core/main.sh" --hide-menubar --full-screen
