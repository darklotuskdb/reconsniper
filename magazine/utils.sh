#!/bin/bash

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${GREEN}"
	echo '
  ______                         ______       _                   
 / _____)                       / _____)     (_)                  
( (____   ____ ___  ____  _____( (____  ____  _ ____  _____  ____ 
 \____ \ / ___) _ \|  _ \| ___ |\____ \|  _ \| |  _ \| ___ |/ ___)
 _____) | (__| |_| | |_| | ____|_____) ) | | | | |_| | ____| |    
(______/ \____)___/|  __/|_____|______/|_| |_|_|  __/|_____)_|    
                   |_|                         |_|                
	'
    echo -e "${NC}"
echo -e "\e[33m============= Made By Kamaldeep Bhati (@DarkLotusKDB) <3 ================\e[0m\n\n"
}

log_info() {
    echo -e "${GREEN}[+] $1${NC}"
}

log_error() {
    echo -e "${RED}[-] $1${NC}"
}

check_dependency() {
    command -v "$1" >/dev/null 2>&1 || {
        log_error "$1 is not installed. Please install it."
        exit 1
    }
}
