#!/bin/sh
LOG_FILE="log.txt"
OS=MacOS64
MINICONDA_FILENAME=Miniconda3-latest-MacOSX-x86_64.sh
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
> ${LOG_FILE} 

# check arguments. if log is given as arg. excution output should be visible while running, otherwise output should be saved in log.txt
if [[ $1 == log ]]
then
    exec 3>&1 
else
    exec 3>&1 1>>${LOG_FILE} 2>&1
fi

process_start()
{
    echo  | tee /dev/fd/3 
    echo "MintPy" | tee /dev/fd/3   
    echo "The Miami INsar Time-series software in PYthon" | tee /dev/fd/3  
    echo "Version 1.2.3" | tee /dev/fd/3      
    echo  | tee /dev/fd/3 
    echo "Installation starting..." | tee /dev/fd/3
    echo "Operating System: ${OS}" | tee /dev/fd/3
    echo "You may follow the installtion in log.txt" 1>&3
}

process_exit()
{
    echo  | tee /dev/fd/3 
    echo "${RED}ERROR${NC}" 1>&3
    echo "Read the log file for more details, log.txt" 1>&3
    echo "You may use the README to install MintPy manually." | tee /dev/fd/3
    echo "If MintPy is already installed on your machine, please uninstall/remove it before installing the new version." | tee /dev/fd/3
    echo  | tee /dev/fd/3 
    exit 1
}

process_completed()
{
    echo  | tee /dev/fd/3 
    echo "${GREEN}MintPy is installed successfully.${NC}" | tee /dev/fd/3
    echo "For more detials about installtion steps please read the log.txt" 1>&3
    echo  | tee /dev/fd/3 
}

process_start

if [ -z ${PYTHONPATH+x} ]; then export PYTHONPATH=""; fi

echo "Setting environment variables..." | tee /dev/fd/3
##--------- MintPy ------------------##
export MINTPY_HOME=~/tools/MintPy
export PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}
export PATH=${PATH}:${MINTPY_HOME}/mintpy
export CONDA_PREFIX=~/tools/miniconda3

##--------- PyAPS -------------------##
export PYAPS_HOME=~/tools/PyAPS
export PYTHONPATH=${PYTHONPATH}:${PYAPS_HOME}


## update packages, install git and wget
apt update
apt-get update --yes && apt-get upgrade --yes
# apt-get install --yes git wget


if ! command -v git &> /dev/null
then
    echo "Installing git..." | tee /dev/fd/3
    apt-get install --yes git wget
fi

if ! command -v wget &> /dev/null
then
    echo "Installing wget..." | tee /dev/fd/3
    apt-get install --yes git wget
fi

# download source code MintPy and 
{ # try
    echo  | tee /dev/fd/3 
    echo "Downloading MintPy source code..." | tee /dev/fd/3
    echo "Destination: ${MINTPY_HOME}" | tee /dev/fd/3
    git clone https://github.com/insarlab/MintPy.git $MINTPY_HOME
    #save your output
    echo "Mintpy downloaded!" | tee /dev/fd/3

} || { # catch
    # save log for exception 
    echo "${RED}Could not download Mintpy!${NC}" | tee /dev/fd/3
    process_exit
}


# download and install miniconda3
mkdir -p ${HOME}/tools
cd ${HOME}/tools

# echo  | tee /dev/fd/3 
{ # try
    echo "Downloading Miniconda for ${OS} ..." | tee /dev/fd/3
    wget https://repo.anaconda.com/miniconda/${MINICONDA_FILENAME} &&
    #save your output
    echo "Miniconda Installer downloaded!" | tee /dev/fd/3

} || { # catch
    # save log for exception 
    echo "${RED}Could not download Miniconda!${NC}" | tee /dev/fd/3
    process_exit
}

echo  | tee /dev/fd/3 
{ # try
    echo "Installing Miniconda ..." | tee /dev/fd/3
    echo "Destination: ${CONDA_PREFIX}" | tee /dev/fd/3
    echo "The installation process may take several minutes."  | tee /dev/fd/3
    chmod +x ${MINICONDA_FILENAME} &&
    ./${MINICONDA_FILENAME} -b -p ${HOME}/tools/miniconda3 &&
    ~/tools/miniconda3/bin/conda init bash &&
    #save your output
    echo "Miniconda installed successfully." | tee /dev/fd/3

} || { # catch
    # save log for exception 
    echo "${RED}Miniconda Installation failed!" | tee /dev/fd/3
    process_exit
}

# setup environment variable
export PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
export PATH=${MINTPY_HOME}/mintpy:${CONDA_PREFIX}/bin:${PATH}

# download source code PyAPS  
{ # try
    echo  | tee /dev/fd/3 
    echo "Downloading PyAPS source code..." | tee /dev/fd/3
    echo "Destination: ${PYAPS_HOME}" | tee /dev/fd/3
    git clone https://github.com/yunjunz/pyaps3.git $PYAPS_HOME/pyaps3
    #save your output
    echo "PyAPS downloaded!" | tee /dev/fd/3

} || { # catch
    # save log for exception 
    echo "${RED}Could not download PyAPS!${NC}" | tee /dev/fd/3
    process_exit
}

echo  | tee /dev/fd/3 
# install dependencies
{ # try
    echo "Installing dependencies..." | tee /dev/fd/3
    echo "The installation process may take several minutes."  | tee /dev/fd/3
    $CONDA_PREFIX/bin/conda config --add channels conda-forge &&
    $CONDA_PREFIX/bin/conda install --yes --file $MINTPY_HOME/docs/conda.txt &&
    $CONDA_PREFIX/bin/pip install git+https://github.com/tylere/pykml.git &&

    # install dependencies with conda
    # $CONDA_PREFIX/bin/conda config --add channels conda-forge
    # $CONDA_PREFIX/bin/conda install --yes --file $MINTPY_HOME/docs/conda.txt
    # $CONDA_PREFIX/bin/pip install git+https://github.com/tylere/pykml.git

    #save your output
    echo "Dependencies installed successfully." | tee /dev/fd/3

} || { # catch
    # save log for exception 
    echo "${RED}Dependencies couldn't be installed!" | tee /dev/fd/3
    process_exit
}


echo  | tee /dev/fd/3 
# test installation
{ # try
    echo "Testing Installation..." | tee /dev/fd/3
    python -c "import mintpy; print(mintpy.version.description)" &&
    smallbaselineApp.py -h &&
    tropo_pyaps3.py -h

    echo "Installation test was successfull."  | tee /dev/fd/3    
    
    #save your output
    process_completed

} || { # catch
    # save log for exception 
    echo "Installation could not be completed."  | tee /dev/fd/3
    echo "Python test failed!"  | tee /dev/fd/3
    process_exit
}