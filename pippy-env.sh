#!/bin/bash -i

#========================================================================================
# Title           : pyenv-setup.sh
# Description     : This script will setup pyenv and pipenv to play nicely
#                   together and setup your virtualenv with the correct python version.
# Author		      : Igor Schouten
# Github          : https://github.com/ischouten/pyenv-setup
# Date            : 20190330
# Version         : 0.1
# Usage		        : bash ./pyenv-setup.sh
# Notes           : Tested on Ubuntu 18.04
# License         : GPLv3
#========================================================================================

PYENV_URL=https://github.com/yyuu/pyenv.git
DEFAULT_PYTHON=3.7.3

show_usage () {
    echo "Usage: ${0}" >&2
    echo "Configure pyenv in the current working folder." >&2
    exit 1
}

# Make sure command has right privileges
if [[ ${UID} -eq 0 ]]; then
  echo 'Please do not run as root.'
  show_usage
  exit 1
fi

# Update repos
sudo apt-get -y update
if [[ "${?}" -ne 0 ]]; then
  echo 'Could not update repository.' >&2
  exit 1
fi

# Install necessary packages to install custom python versions
sudo apt install -y build-essential libffi-dev git libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl

# Clone pyenv and allow it to be used.
if [[ -d ~/bin/pyenv ]]; then
  echo "Pyenv installed already. Skipping installation."
else
  mkdir ~/bin
  PYENV_ROOT="${HOME}/bin/pyenv"
  echo ${PYENV_ROOT}
  git clone ${PYENV_URL} ${PYENV_ROOT}

  echo 'export PYENV_ROOT="${HOME}/bin/pyenv"' >> ~/.bashrc
  echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# Change pipenv default to create .venv in project directory.
echo 'export PIPENV_VENV_IN_PROJECT="true"' >> ~/.bashrc

source ~/.bashrc

# Install the target python version if necessary and change the config for the project dir to use this version.
# If the .python-version file is already present in the cloned repo, use that version.
if [[ ! -f .python-version && -f Pipfile ]]; then
  # If there is no .python-version file, but there is a Pipfile, extract a version from it.
  TARGET_PYTHON_VERSION=$(awk -F\= '/python_version/ {print $2}' Pipfile | tr -d \")
  echo "Target version in Pipfile: {$TARGET_PYTHON_VERSION}"
elif [[ -f .python-version ]]; then
  TARGET_PYTHON_VERSION=cat .python-version
else
  read -p 'There seems to be no python version prescribed yet. Please suggest something (default: 3.7.3):' TARGET_PYTHON_VERSION
fi

if [[ -z ${TARGET_PYTHON_VERSION} ]]; then
  TARGET_PYTHON_VERSION=${DEFAULT_PYTHON}
fi

# To prevent anyone forgetting to do so, add the .venv folder to gitignore.
touch .gitignore
echo '.venv/' >> .gitignore

echo "Going to use python version ${TARGET_PYTHON_VERSION}"

# Install the new Python version (If it is already installed on the system, just skip it.)
pyenv install ${TARGET_PYTHON_VERSION} -s

# Set the currrent dir to use this version (creates the .python-version file)
pyenv local ${TARGET_PYTHON_VERSION}

# Install pipenv for this activated python version.
pip install --upgrade pip
pip install pipenv

# Activate the new pipenv environment with the Pipfile's requirements.
pipenv install

exec $SHELL