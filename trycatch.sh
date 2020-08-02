#!/bin/sh

linux=false
mac=false
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    linux=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # echo "MAC"
    mac=true
fi

OS=
MINICONDA_FILENAME=

get_os()
{
    if $mac; then
        OS="MacOS64"
    elif $linux; then
        OS="Linux64"
    fi
}

get_miniconda_file()
{
    if $mac; then
        MINICONDA_FILENAME="Miniconda3-latest-MacOSX-x86_64.sh"
    elif $linux; then
        MINICONDA_FILENAME="Miniconda3-latest-Linux-x86_64.sh"
    fi
}

get_os
get_miniconda_file
# echo $variable
echo $OS
echo $MINICONDA_FILENAME


