#!/bin/bash

dnsScan() {
  echo "[*] Running DNS Scan"
  /opt/dnscan/dnscan.py -d "$tar" -w filtered-Master_wordlist.txt -r -L $BASE_DIR/config/dns-resolvers.txt -t 50 -D -o dns-scan-output.txt

  grep "$tar" dns-scan-output.txt | grep -vE "@$tar|\*" | awk '{print $1}' | sed '/^$/d' | sort -u >> dns-scan.txt
  echo -e "\n[+] DNS scan completed. Results saved to dns-scan.txt"
}

dnsXscan(){
dnsx -l vertical-subdomains.txt -all -resp -retry 3 -t 50 -o dnsx_results.txt
echo -e "\n[+] DNS scan completed. Results saved to dnsx_results.txt"
}

dnsXscan
dnsScan

