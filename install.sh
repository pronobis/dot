#!/bin/bash

## -------------------------------------------------------------
## General
## -------------------------------------------------------------
# Set path to the root .dot dir
DOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Interrupt the script on first error
set -e

# Import tools
. $DOT_DIR/shell/tools.bash

# Header
echo "==============================="
echo "Dotfiles Installer "
echo "==============================="
echo "Using dot files in: ${DOT_DIR}"


## ---------------------------------------------------------
## Install setup.profile
## ---------------------------------------------------------
PROFILE_FILE="$HOME/.profile"
echo
echo "-------------------------------"
echo "Setting up $PROFILE_FILE"
echo "-------------------------------"

# Create .profile
if [ ! -f ${PROFILE_FILE} ]
then
    touch "${PROFILE_FILE}"
fi

## Add the setup.profile to the ~/.profile if not yet added
if ! grep -q ". $DOT_DIR/setup.profile" "${PROFILE_FILE}"
then
    cat << EOF >> ${PROFILE_FILE}

## ---------------
## Setup dot files
## ---------------
. ${DOT_DIR}/setup.profile

EOF
    echo "Done!"
else
    echo "Already set up, doing nothing!"
fi



## ---------------------------------------------------------
## Install setup.bash
## ---------------------------------------------------------
BASHRC_FILE="$HOME/.bashrc"
echo
echo "-------------------------------"
echo "Setting up $BASHRC_FILE"
echo "-------------------------------"

# Create .bashrc
if [ ! -f ${BASHRC_FILE} ]
then
    touch "${BASHRC_FILE}"
fi

## Add the setup.bash to the ~/.profile if not yet added
if ! grep -q ". $DOT_DIR/setup.bash" "${BASHRC_FILE}"
then
    cat << EOF >> ${BASHRC_FILE}

## ---------------
## Setup dot files
## ---------------
. ${DOT_DIR}/setup.bash

EOF
    echo "Done!"
else
    echo "Already set up, doing nothing!"
fi



## ---------------------------------------------------------
## Create links to binaries
## ---------------------------------------------------------
echo
echo "-------------------------------"
echo "Creating links to binaries "
echo "-------------------------------"
dot_link_bin $DOT_DIR "scripts/sys"
dot_link_bin $DOT_DIR "scripts/cmd"
echo "Done!"


echo
echo "-------------------------------"
echo "All done! "
echo "Please install modules now. "
echo "-------------------------------"
