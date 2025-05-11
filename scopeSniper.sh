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
    echo "  -d  Run DNS check"
    echo "  -h  Run HTTP probing"
    exit 1
}

# Initialize flags
SUB_ENUM=false
DNS_CHECK=false
HTTP_PROBE=false
ALL=false

# No arguments at all
if [ $# -lt 1 ]; then
    show_help
fi

# Parse options
while getopts "sdha" opt; do
    case $opt in
        s) SUB_ENUM=true ;;
        d) DNS_CHECK=true ;;
        h) HTTP_PROBE=true ;;
        a) ALL=true ;;
        *) show_help ;;
    esac
done

shift $((OPTIND -1))
tar=$1

# Validate input
if [ -z "$tar" ] || { [ "$SUB_ENUM" = false ] && [ "$DNS_CHECK" = false ] && [ "$HTTP_PROBE" = false ] && [ "$ALL" = false ]; }; then
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

if [ "$ALL" = true ] || [ "$DNS_CHECK" = true ]; then
    source "$BASE_DIR/functions/dns_check.sh"
    run_dns_check "$tar"
fi

if [ "$ALL" = true ] || [ "$HTTP_PROBE" = true ]; then
    source "$BASE_DIR/functions/http_probe.sh"
    run_http_probe "$tar"
fi
