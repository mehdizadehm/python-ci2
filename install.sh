echo "Installing MintPy ..."

if [ -z ${PYTHONPATH+x} ]; then export PYTHONPATH=""; fi

##--------- MintPy ------------------##
export MINTPY_HOME=~/tools/MintPy
export PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}
export PATH=${PATH}:${MINTPY_HOME}/mintpy

##--------- PyAPS -------------------##
export PYAPS_HOME=~/tools/PyAPS
export PYTHONPATH=${PYTHONPATH}:${PYAPS_HOME}


## update packages, install git and wget
apt update
apt-get update --yes && apt-get upgrade --yes
apt-get install --yes git wget

# download source code MintPy and 
git clone https://github.com/insarlab/MintPy.git $MINTPY_HOME

# download and install miniconda3
mkdir -p ${HOME}/tools
cd ${HOME}/tools
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/tools/miniconda3
~/tools/miniconda3/bin/conda init bash

# setup environment variable
export PYTHONPATH=${PYTHONPATH}:${MINTPY_HOME}:${PYAPS_HOME}
export PATH=${MINTPY_HOME}/mintpy:${CONDA_PREFIX}/bin:${PATH}
# download source code PyAPS
git clone https://github.com/yunjunz/pyaps3.git $PYAPS_HOME/pyaps3
# install dependencies
conda config --add channels conda-forge
conda install --yes --file $MINTPY_HOME/docs/conda.txt
pip install git+https://github.com/tylere/pykml.git

# test installation
python -c "import mintpy; print(mintpy.version.description)"
smallbaselineApp.py -h
tropo_pyaps3.py -h

