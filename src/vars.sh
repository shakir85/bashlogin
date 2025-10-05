# 
# Global variables
# 
# Resources:
#   - Symbols: https://unicode-table.com/en/sets/arrow-symbols/
#   - Bash colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting
#   - Figlet fonts: http://www.figlet.org/fontdb_example.cgi

# OS info
OS=$(lsb_release -si)
OS_RELEASE=$(lsb_release -sc)
OS_VERSION=$(grep "VERSION_ID" < /etc/os-release | cut -c 13-17)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up//')

# Colors
ColorReset='\e[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\e[93m'
Blue='\E[1;34m'
Dim='\e[2m'
Bold=$(tput bold)
Normal=$(tput sgr0)
