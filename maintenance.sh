#!/usr/bin/env bash
set -e

## Author: Tommy Miland (@tmiland) - Copyright (c) 2019


######################################################################
####                   Nginx Maintenance mode                     ####
####      Easily toggle on or off maintenance mode with nginx     ####
####                   Maintained by @tmiland                     ####
######################################################################


version='1.0.1'
#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2019 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#
# Declare variables
SERVICE_NAME=nginx.service
maintenance_file_path=/etc/nginx/html/server-error-pages/_site
GITHUB_REPO=https://github.com/tmiland/Nginx-Maintenance-Mode
# Icons used for printing
ARROW='➜'
DONE='✔'
ERROR='✗'
WARNING='⚠'
# Colors used for printing
RED='\033[0;31m'
BLUE='\033[0;34m'
BBLUE='\033[1;34m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
DARKORANGE="\033[38;5;208m"
CYAN='\033[0;36m'
DARKGREY="\033[48;5;236m"
NC='\033[0m' # No Color
# Text formatting used for printing
BOLD="\033[1m"
DIM="\033[2m"
UNDERLINED="\033[4m"
INVERT="\033[7m"
HIDDEN="\033[8m"
# Command arguments
server_name=`echo "$1"`
toggle=`echo "$2"`

# Show service status - @FalconStats
show_status () {
  # Add more services if you want to monitor 
  declare -a services=(
    "nginx"
    "httpd"
  )
  declare -a serviceName=(
    "Nginx"
    "Apache"
  )
  declare -a serviceStatus=()
  for service in "${services[@]}"
  do
    serviceStatus+=($(systemctl is-active "$service.service"))
  done
  echo ""
  for i in ${!serviceStatus[@]}
  do
    if [[ "${serviceStatus[$i]}" == "active" ]]; then
      line+="${GREEN}${NC}${serviceName[$i]}: ${GREEN}● ${serviceStatus[$i]}${NC} "
    else
      line+="${serviceName[$i]}: ${RED}▲ ${serviceStatus[$i]}${NC} "
    fi
  done
  echo -e "$line"
}

SHOW_STATUS=$(show_status)

# Check input
check_input() {
  echo ""
  echo -e "${ORANGE}${INVERT}${WARNING}${BOLD} Nginx Maintenance Mode ${NC}"
  echo ""
  echo -e "${ORANGE}${ARROW} Usage:${NC}${GREEN} ./maintenance.sh [hostname] [on/off] ${NC}"
  echo ""
}

INPUT_CHECK=$(check_input)

# Exit Script
exit_script () {
  printf "${GREEN}"
  cat << "EOF"
     _   __      _
    / | / /___ _(_)___  _  __
   /  |/ / __ `/ / __ \| |/_/
  / /|  / /_/ / / / / />  <
 /_/ |_/\__, /_/_/ /_/_/|_|
       /____/
     __  ___      _       __
    /  |/  /___ _(_)___  / /____  ____  ____ _____  ________
   / /|_/ / __ `/ / __ \/ __/ _ \/ __ \/ __ `/ __ \/ ___/ _ \
  / /  / / /_/ / / / / / /_/  __/ / / / /_/ / / / / /__/  __/
 /_/  /_/\__,_/_/_/ /_/\__/\___/_/ /_/\__,_/_/ /_/\___/\___/

EOF
  printf "${NC}"
  echo -e "
    This script is fueled by coffee ☕

   ${GREEN}${DONE}${NC} ${BBLUE}Paypal${NC} ${ARROW} ${ORANGE}https://paypal.me/milanddata${NC}
   ${GREEN}${DONE}${NC} ${BBLUE}BTC${NC}    ${ARROW} ${ORANGE}3MV69DmhzCqwUnbryeHrKDQxBaM724iJC2${NC}
   ${GREEN}${DONE}${NC} ${BBLUE}BCH${NC}    ${ARROW} ${ORANGE}qznnyvpxym7a8he2ps9m6l44s373fecfnv86h2vwq2${NC}
  "
  echo -e "Documentation for this script is available here: ${ORANGE}\n${ARROW} ${GITHUB_REPO}${NC}\n"
  echo -e "${ORANGE}${ARROW} Goodbye.${NC} ☺"
  echo ""
  exit
}

header() {
  printf "${BLUE}"
  cat << EOF

╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                      Nginx Maintenance mode                       ║
║                                                                   ║
║        Easily toggle on or off maintenance mode with nginx        ║
║                                                                   ║
║             Version: $version Maintained by @tmiland                 ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
  printf "${NC}"
  echo ""
  echo -e "Documentation for this script is available here: ${ORANGE}\n ${ARROW} ${GITHUB_REPO}${NC}\n"
}

# Make sure that the script runs with root permissions
chk_permissions () {
  if [[ "$EUID" != 0 ]]; then
    echo -e "${RED}${ERROR} This action needs root permissions.${NC} Please enter your root password...";
    cd "$CURRDIR"
    su -s "$(which bash)" -c "./$SCRIPT_FILENAME"
    cd - > /dev/null

    exit 0;
  fi
}

# Make sure the maintenance file path exists
function checkDirExists() {
  if [ ! -d "$maintenance_file_path" ]
  then
    echo "Cannot find $maintenance_file_path."
    exit 1
  fi
}

# Check if maintenance mode is off
function checkToggleOn() {
  if [ ! -e "$maintenance_file_path/$server_name-maintenance-page_on.html" ]
  then
    echo -e "${RED}${ERROR} Maintenance mode is already off for $server_name ${NC}"
    echo -e "${SHOW_STATUS} \n"
    exit 1
  fi
}

# Check if maintenance mode is on
function checkToggleOff() {
  if [ -e "$maintenance_file_path/$server_name-maintenance-page_on.html" ]
  then
    echo -e "${RED}${ERROR} Maintenance mode is already on for $server_name ${NC}"
    echo -e "${SHOW_STATUS} \n"
    exit 1
  fi
}

# only runs if nginx -t succeeds
safe_reload() {
  nginx -t &&
  systemctl reload $SERVICE_NAME
}

# Restart Nginx
restartNginx () {
  printf "\n-- ${GREEN}${ARROW} reloading Nginx\n\n ${NC}"
  safe_reload
  sleep 2
  echo -e "${SHOW_STATUS} "
  #systemctl show -p SubState --value $SERVICE_NAME
  printf "\n"
  echo -e "${GREEN}${DONE} Nginx has been reloaded ${NC}"
  sleep 3
}

#check command input
if [[ -z "$1" && -z "$2" ]];
then
  echo -e "${INPUT_CHECK}"
  exit 0
fi
main() {
  if [ "$2" == "on" ]
  then
    chk_permissions
    checkDirExists
    checkToggleOff
    # Enable Maintenance Mode
    echo -e "${ORANGE}${ARROW} Enabling maintenance mode.. ${NC}"
    cd $maintenance_file_path || exit 1
    cp -rp maintenance-page_off.html $server_name-maintenance-page_on.html
    echo -e "${GREEN}${DONE} Maintenance mode has been enabled ${NC}"
    restartNginx
elif [ "$2" == "off" ]
  then
    chk_permissions
    checkDirExists
    checkToggleOn
    # Disable Maintenance Mode
    echo -e "${ORANGE}${ARROW} Disabling maintenance mode.. ${NC}"
    cd $maintenance_file_path || exit 1
    rm $server_name-maintenance-page_on.html
    echo -e "${GREEN}${DONE} Maintenance mode has been disabled ${NC}"
    restartNginx
  else
    echo -e "${INPUT_CHECK}"
  fi
}

header
main $@
exit_script
