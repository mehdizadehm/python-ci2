#!/bin/sh


LOG_FILE="log.txt"
> ${LOG_FILE} 

# check arguments. if docker is given as arg. excution output should be visible while running, otherwise output should be saved in log.txt
if [[ "$1" == log ]]
then
    exec 3>&1 
    echo "log is given‚"
else
    exec 3>&1 1>>${LOG_FILE} 2>&1
    echo "log is not given‚"
fi


process_exit()
{
    echo "Read the log file for more details. install.log"
    echo "You can use the README to install MintPy manually."
}

# process_exit


command=ls
echo  | tee /dev/fd/3 
echo  | tee /dev/fd/3 
echo  | tee /dev/fd/3 
echo  | tee /dev/fd/3 
echo "This is both the log and the console" | tee /dev/fd/3

echo "salam"

ls 


# Miniconda3-latest-MacOSX-x86_64.sh

# Miniconda3-latest-Linux-x86_64.sh