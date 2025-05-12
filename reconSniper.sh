#!/bin/bash

# Source utilities and print the banner
BASE_DIR=$(dirname "$(realpath "$0")")
source "$BASE_DIR/magazine/utils.sh"
print_banner

# Help menu
show_help() {
    echo "Usage: $0 [-s] [-d] [-h] [-a] <domain>"
    echo "  -a  Run all"
    echo "  -s  Run Vertical Subdomain Enumeration"
    echo "  -z  Run Horizontal Subdomain Enumeration"
    echo "  -c  Run to Generate Custom Subdomain Wordlist"
    echo "  -d  Run DNS check"
    echo "  -x  Run HTTP probing and Screenshots"
    exit 1
}

# Initialize flags
SUB_ENUM=false
CS_Word=false
DNS_CHECK=false
HTTP_PROBE=false
ALL=false

# No arguments at all
if [ $# -lt 1 ]; then
    show_help
fi

# Parse options
while getopts "aszcdhx" opt; do
    case $opt in
        s) SUB_ENUM=true ;;
        c) CS_Word=true ;;
        d) DNS_CHECK=true ;;
        x) HTTP_PROBE=true ;;
        a) ALL=true ;;
        *) show_help ;;
    esac
done

shift $((OPTIND -1))
tar=$1

# Validate input
if [ -z "$tar" ] || { [ "$SUB_ENUM" = false ] && [ "$DNS_CHECK" = false ] && [ "$CS_Word" = false ] && [ "$HTTP_PROBE" = false ] && [ "$ALL" = false ]; }; then
    echo "[!] Error: Please provide at least one flag and a domain."
    show_help
fi

# Create output directory
Output_Location() {
    tstamp=$(date +%F)
    mkdir -p "$BASE_DIR/output/$tar/${tstamp}"
    cd "$BASE_DIR/output/$tar/${tstamp}" || exit
}

# Run selected modules
if [ "$ALL" = true ] || [ "$SUB_ENUM" = true ]; then
    Output_Location
    source "$BASE_DIR/magazine/Vertical-Subdomain-Enumeration.sh"

fi

if [ "$ALL" = true ] || [ "$CS_Word" = true ]; then
	Output_Location
    source "$BASE_DIR/magazine/Custom-Subdomain-Wordlist.sh"
fi

if [ "$ALL" = true ] || [ "$DNS_CHECK" = true ]; then
	Output_Location
    source "$BASE_DIR/magazine/DNS-Check.sh"
fi

if [ "$ALL" = true ] || [ "$HTTP_PROBE" = true ]; then
	Output_Location
    source "$BASE_DIR/magazine/Screenshot-And-Ports.sh"
    
fi
