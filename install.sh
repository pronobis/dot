#!/bin/sh

dot_shell=$(cd "${0%/*}/shell" && pwd); . "$dot_shell/install_main_header.sh"


## ---------------------------------------------------------
## Install in .profile
## ---------------------------------------------------------
PROFILE_FILE="$HOME/.profile"
# Header
print_header "Setting up $PROFILE_FILE"

# Create .profile
if [ ! -f ${PROFILE_FILE} ]
then
    touch "${PROFILE_FILE}"
fi

## Add if not yet added
if ! grep -q ". $DOT_DIR/shell/setup-profile.sh" "${PROFILE_FILE}"
then
    cat << EOF >> ${PROFILE_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup-profile.sh

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
## Install in .bashrc
## ---------------------------------------------------------
BASHRC_FILE="$HOME/.bashrc"
# Header
print_header "Setting up $BASHRC_FILE"

# Create .bashrc
if [ ! -f ${BASHRC_FILE} ]
then
    touch "${BASHRC_FILE}"
fi

## Add if not yet added
if ! grep -q ". $DOT_DIR/shell/setup-rc.sh" "${BASHRC_FILE}"
then
    cat << EOF >> ${BASHRC_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup-rc.sh

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
## Install in .zprofile
## ---------------------------------------------------------
ZPROFILE_FILE="$HOME/.zprofile"
# Header
print_header "Setting up $ZPROFILE_FILE"

# Create .zprofile
if [ ! -f ${ZPROFILE_FILE} ]
then
    touch "${ZPROFILE_FILE}"
fi

## Add if not yet added
if ! grep -q ". $DOT_DIR/shell/setup-profile.sh" "${ZPROFILE_FILE}"
then
    cat << EOF >> ${ZPROFILE_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup-profile.sh

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
## Install in .zshrc
## ---------------------------------------------------------
ZSHRC_FILE="$HOME/.zshrc"
# Header
print_header "Setting up $ZSHRC_FILE"

# Create .zshrc
if [ ! -f ${ZSHRC_FILE} ]
then
    touch "${ZSHRC_FILE}"
fi

## Add if not yet added
if ! grep -q ". $DOT_DIR/shell/setup-rc.sh" "${ZSHRC_FILE}"
then
    cat << EOF >> ${ZSHRC_FILE}

## ---------------
## Setup dot files
## ---------------
export DOT_DIR="${DOT_DIR}"
. ${DOT_DIR}/shell/setup-rc.sh

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
## Install in config.fish
## ---------------------------------------------------------
CONFIG_FISH_FILE="$HOME/.config/fish/config.fish"
# Header
print_header "Setting up $CONFIG_FISH_FILE"

# Create config.fish
if [ ! -f ${CONFIG_FISH_FILE} ]
then
    mkdir -p "$HOME/.config/fish"
    touch "${CONFIG_FISH_FILE}"
fi

## Add if not yet added
if ! grep -q ". $DOT_DIR/shell/setup-config.fish" "${CONFIG_FISH_FILE}"
then
    cat << EOF >> ${CONFIG_FISH_FILE}

## ---------------
## Setup dot files
## ---------------
set -x DOT_DIR "${DOT_DIR}"
source ${DOT_DIR}/shell/setup-config.fish

EOF
    print_status "Done!"
else
    print_status "Already set up, doing nothing!"
fi


## ---------------------------------------------------------
. "$dot_shell/install_main_footer.sh"
