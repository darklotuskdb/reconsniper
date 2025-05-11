#!/bin/bash

echo -e "\e[93m[+] Vertical Subdomain Enumeration\e[0m"
#tar=$1
#tstamp=$(date +%F)
#mkdir -p output/$tar/${tstamp}
#cd output/$tar/${tstamp}

# Shodan (hostname and ssl fields)
shodan search --limit 1000 --fields hostnames hostname:$tar \
  | sed -r 's/\s+//g' \
  | sed '/^$/d' \
  | tr ';' '\n' \
  | grep -i "\.${tar}$" \
  | tee allSD.tmp

shodan search --limit 1000 --fields hostnames ssl:$tar \
  | sed -r 's/\s+//g' \
  | sed '/^$/d' \
  | tr ';' '\n' \
  | grep -i "\.${tar}$" \
  | tee -a allSD.tmp

# Assetfinder
$HOME/go/bin/assetfinder --subs-only $tar | tee -a allSD.tmp

# Subfinder
$HOME/go/bin/subfinder -silent -d $tar | tee -a allSD.tmp

# Sublist3r
sublist3r -d $tar -o $tar.tmp > /dev/null 2>&1
sed 's/<BR>/\n/g' "$tar.tmp" | tee -a allSD.tmp

# Findomain
findomain -t $tar -u $tar.tmp > /dev/null 2>&1
cat "$tar.tmp" | tee -a allSD.tmp

# crt.sh (direct and wildcard)
curl -s "https://crt.sh/?Identity=$tar" \
  | grep ">$tar" \
  | sed 's/<[/]*[TB][DR]>/\n/g' \
  | grep -vE "<|^[\*]*[\.]$tar" \
  | awk 'NF' \
  | sort -u \
  | tee -a allSD.tmp

curl -s "https://crt.sh/?Identity=%.$tar" \
  | grep ">*.$tar" \
  | sed 's/<[/]*[TB][DR]>/\n/g' \
  | grep -vE "<|^[\*]*[\.]*$tar" \
  | awk 'NF' \
  | sort -u \
  | tee -a allSD.tmp

# Final sort and save
sort -u allSD.tmp | tee vertical-subdomains.txt

# Clean up
rm -f *.tmp *.old.txt &> /dev/null
