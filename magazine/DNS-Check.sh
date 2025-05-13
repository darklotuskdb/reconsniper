#!/bin/bash


dnsScan() {
  echo "[*] Starting DNS scan for $tar"
  rm -f dns-scan-output.txt dns-scan-subdomains.txt  # Clean old outputs

  # Run dnscan
  /opt/dnscan/dnscan.py -d "$tar" -w filtered-Master_wordlist.txt -L "$BASE_DIR/config/dns-resolvers.txt" -t 70 -D -o dns-scan-output.txt

  echo "[*] Filtering scan output..."
  grep -Eo "([a-zA-Z0-9_-]+\.)+${tar//./\\.}" dns-scan-output.txt | \
    grep -viE '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | \
    grep -viE '^(ip6|ip4|v=|include:|spf1|dmarc|_spf|^ns[0-9]|dns[0-9])' | \
    sort -u > dns-scan-subdomains.txt

  cat dns-scan-subdomains.txt >> all-subdomains.txt
  sort -u all-subdomains.txt -o all-subdomains.txt
  
  
  

  # Run dnscan
  /opt/dnscan/dnscan.py -l all-subdomains.txt -w base_words.txt -r -m 4 -L "$BASE_DIR/config/dns-resolvers.txt" -t 70 -D -o dns-scan-custom-vertical-output.txt

  echo "[*] Filtering scan output..."
  grep -Eo "([a-zA-Z0-9_-]+\.)+${tar//./\\.}" dns-scan-custom-vertical-output.txt | \
    grep -viE '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | \
    grep -viE '^(ip6|ip4|v=|include:|spf1|dmarc|_spf|^ns[0-9]|dns[0-9])' | \
    sort -u > dns-scan-custom-vertical-subdomains.txt

  cat dns-scan-custom-vertical-subdomains.txt >> all-subdomains.txt
  sort -u all-subdomains.txt -o all-subdomains.txt

  echo "[+] DNS scan complete."
  echo "    Cleaned subdomains saved to: dns-scan-subdomains.txt"
    echo "    Cleaned subdomains saved to: dns-scan-custom-vertical-subdomains.txt"
  echo "    Combined results in:         all-subdomains.txt"
}


dnsXscan(){
dnsx -l all-subdomains.txt -all -resp -retry 3 -t 50 -o dnsx_results.txt
cat dnsx_results.txt | cut -d " " -f 1 | grep -i "\.$tar$" | grep -v '*'| sort -u > alive-dnsx_results.txt
echo -e "\n[+] DNS scan completed. Results saved to dnsx_results.txt"
}


dnsScan
dnsXscan

