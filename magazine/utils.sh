#!/bin/bash

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${GREEN}"
	echo '
 ______                             ______       _                   
(_____ \                           / _____)     (_)                  
 _____) )_____  ____ ___  ____    ( (____  ____  _ ____  _____  ____ 
|  __  /| ___ |/ ___) _ \|  _ \    \____ \|  _ \| |  _ \| ___ |/ ___)
| |  \ \| ____( (__| |_| | | | |   _____) ) | | | | |_| | ____| |    
|_|   |_|_____)\____)___/|_| |_|  (______/|_| |_|_|  __/|_____)_|    
                                                  |_|                
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
