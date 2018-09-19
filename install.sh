#!/bin/sh

dot_shell=$(cd "${0%/*}/shell" && pwd); . "$dot_shell/install_main_header.sh"


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

## Add the setup.profile if not yet added
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

## Add the setup.bash if not yet added
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


## ---------------------------------------------------------
## Install setup.fish
## ---------------------------------------------------------
CONFIG_FISH_FILE="$HOME/.config/fish/config.fish"
# Header
print_header "Setting up $CONFIG_FISH_FILE"

# Create config.fish
if [ ! -f ${CONFIG_FISH_FILE} ]
then
    touch "${CONFIG_FISH_FILE}"
fi

## Add the setup.fish if not yet added
if ! grep -q ". $DOT_DIR/shell/setup.fish" "${CONFIG_FISH_FILE}"
then
    cat << EOF >> ${CONFIG_FISH_FILE}

## ---------------
## Setup dot files
## ---------------
set -x DOT_DIR "${DOT_DIR}"
source ${DOT_DIR}/shell/setup.fish

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
. "$dot_shell/install_main_footer.sh"
