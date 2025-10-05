#!/usr/bin/env bash

source src/vars.sh
source src/resources.sh
source src/status.sh
source src/users.sh


# Display hostname in a fancy way using figlet with 'slant' font
# -w is for width, -k is to keep the aspect ratio
figlet -w 120 -f slant -k "$HOSTNAME"

LoggedInUsers
echo ""
sysInfo
echo ""
resourcesInfo
echo ""
echo -e -n "$Dim[Services]"
serviceStatus docker
serviceStatus ssh
echo -e "$ColorReset"
