# -*- mode: sh -*-

# Include guard
[ -n "$DOT_SETUP_FORMATTING" ] && return || readonly DOT_SETUP_FORMATTING=1

# Regular Colors
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'

# High Intensity
LIGHT_BLACK='\e[90m'
LIGHT_RED='\e[91m'
LIGHT_GREEN='\e[92m'
LIGHT_YELLOW='\e[93m'
LIGHT_BLUE='\e[94m'
LIGHT_PURPLE='\e[95m'
LIGHT_CYAN='\e[96m'
LIGHT_WHITE='\e[97m'

# Background
BG_BLACK='\e[40m'
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_PURPLE='\e[45m'
BG_CYAN='\e[46m'
BG_WHITE='\e[47m'

# High Intensity backgrounds
BG_LIGHT_BLACK='\e[100m'
BG_LIGHT_RED='\e[101m'
BG_LIGHT_GREEN='\e[102m'
BG_LIGHT_YELLOW='\e[103m'
BG_LIGHT_BLUE='\e[104m'
BG_LIGHT_PURPLE='\e[105m'
BG_LIGHT_CYAN='\e[106m'
BG_LIGHT_WHITE='\e[107m'

# Fonts
BOLD='\e[1m'
UNDERLINE='\e[4m'

# Reset
NO_FORMAT='\e[0m'
NO_COLOR='\e[39m'
NO_BOLD='\e[29m'
NO_UNDERLINE='\e[24m'


# Setting functions
set_format()
{
    echo -e -n "$1"
}

clear_format()
{
    echo -e -n "$NO_FORMAT"
}
