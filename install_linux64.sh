echo "Installing MintPy ..."

if [ -z ${PYTHONPATH+x} ]; then export PYTHONPATH=""; fi

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
    apt-get install --yes git wget
fi

if ! command -v wget &> /dev/null
then
    apt-get install --yes git wget
fi

# download source code MintPy and 
git clone https://github.com/insarlab/MintPy.git $MINTPY_HOME

# download and install miniconda3
mkdir -p ${HOME}/tools
cd ${HOME}/tools


{ # try

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh &&
    #save your output
    echo "Miniconda Installer downloaded!"

} || { # catch
    # save log for exception 
    echo "Could not download Miniconda!"
    exit 1
}



{ # try

    chmod +x Miniconda3-latest-Linux-x86_64.sh &&
    ./Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/tools/miniconda3 &&
    ~/tools/miniconda3/bin/conda init bash &&
    #save your output
    echo "Miniconda installed successfully!"

} || { # catch
    # save log for exception 
    echo "Miniconda Installation failed"
    exit 1
}

# setup environment variable
export PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
export PATH=${MINTPY_HOME}/mintpy:${CONDA_PREFIX}/bin:${PATH}
# download source code PyAPS
git clone https://github.com/yunjunz/pyaps3.git $PYAPS_HOME/pyaps3

# install dependencies
{ # try

    conda config --add channels conda-forge &&
    conda install --yes --file $MINTPY_HOME/docs/conda.txt &&
    pip install git+https://github.com/tylere/pykml.git &&

    # install dependencies with conda
    # $CONDA_PREFIX/bin/conda config --add channels conda-forge
    # $CONDA_PREFIX/bin/conda install --yes --file $MINTPY_HOME/docs/conda.txt
    # $CONDA_PREFIX/bin/pip install git+https://github.com/tylere/pykml.git

    #save your output
    echo "shod"

} || { # catch
    # save log for exception 
    echo "nashod"
}



test installation
{ # try

    python -c "import mintpy; print(mintpy.version.description)" &&
    smallbaselineApp.py -h &&
    tropo_pyaps3.py -h
    
    #save your output
    echo "MitPy was installed successfully!"

} || { # catch
    # save log for exception 
    echo "Installation could not be completed!"
    echo "Python test failed!"
    exit 1
}