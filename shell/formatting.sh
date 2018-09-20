# -*- mode: sh -*-
## ----------------------------------------------------------
## Formatting and colors for POSIX shells
## ----------------------------------------------------------

# Include guard
[ -n "$DOT_FORMATTING_SH" ] && return || readonly DOT_FORMATTING_SH=1


# Regular Colors
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

# High Intensity
LIGHT_BLACK='\033[90m'
LIGHT_RED='\033[91m'
LIGHT_GREEN='\033[92m'
LIGHT_YELLOW='\033[93m'
LIGHT_BLUE='\033[94m'
LIGHT_PURPLE='\033[95m'
LIGHT_CYAN='\033[96m'
LIGHT_WHITE='\033[97m'

# Background
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# High Intensity backgrounds
BG_LIGHT_BLACK='\033[100m'
BG_LIGHT_RED='\033[101m'
BG_LIGHT_GREEN='\033[102m'
BG_LIGHT_YELLOW='\033[103m'
BG_LIGHT_BLUE='\033[104m'
BG_LIGHT_PURPLE='\033[105m'
BG_LIGHT_CYAN='\033[106m'
BG_LIGHT_WHITE='\033[107m'

# Fonts
BOLD='\033[1m'
UNDERLINE='\033[4m'

# Reset
NO_FORMAT='\033[0m'
NO_COLOR='\033[39m'
NO_BOLD='\033[29m'
NO_UNDERLINE='\033[24m'


# Setting functions
set_format()
{
    printf "$1"
}

clear_format()
{
    printf "$NO_FORMAT"
}
