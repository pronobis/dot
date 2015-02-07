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
print_main_header


## ---------------------------------------------------------
## Install setup.profile
## ---------------------------------------------------------
PROFILE_FILE="$HOME/.profile"
# Header
print_header "Setting up $PROFILE_FILE"

# Create .profile
if [ ! -f ${PROFILE_FILE} ]
then
    touch "${PROFILE_FILE}"
fi

## Add the setup.profile to the ~/.profile if not yet added
if ! grep -q ". $DOT_DIR/shell/setup.profile" "${PROFILE_FILE}"
then
    cat << EOF >> ${PROFILE_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup.profile

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
## Install setup.bash
## ---------------------------------------------------------
BASHRC_FILE="$HOME/.bashrc"
# Header
print_header "Setting up $BASHRC_FILE"

# Create .bashrc
if [ ! -f ${BASHRC_FILE} ]
then
    touch "${BASHRC_FILE}"
fi

## Add the setup.bash to the ~/.profile if not yet added
if ! grep -q ". $DOT_DIR/shell/setup.bash" "${BASHRC_FILE}"
then
    cat << EOF >> ${BASHRC_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup.bash

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


# Footer
print_main_footer
