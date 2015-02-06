#!/bin/bash

# Set path to the root .dot dir
DOT_DIR="$HOME/.dot"

## ---------------------------------------------------------
## Install setup.profile
## ---------------------------------------------------------
PROFILE_FILE="$HOME/.profile"

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
fi


## ---------------------------------------------------------
## Install setup.bash
## ---------------------------------------------------------
BASHRC_FILE="$HOME/.bashrc"

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
fi
