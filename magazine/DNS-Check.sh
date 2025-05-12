#!/bin/bash


dnsXscan(){
dnsx -l vertical-subdomains.txt -all -resp -retry 3 -t 50 -o dnsx_results.txt
echo -e "\n[+] DNS scan completed. Results saved to dnsx_results.txt"
}

dnsScan() {
  echo "[*] Starting live DNS scan for $tar"
  rm -f dns-scan-output.txt dns-scan-clean.txt  # Clean old outputs

  # Start dnscan in the background and write to a live output file
  /opt/dnscan/dnscan.py -d "$tar" -w filtered-Master_wordlist.txt \
    -r -L "$BASE_DIR/config/dns-resolvers.txt" -t 50 -D \
    -o dns-scan-output.txt &

  DNSCAN_PID=$!

  touch dns-scan-clean.txt  # Ensure the clean file exists

  while kill -0 $DNSCAN_PID 2>/dev/null; do
    echo "[*] Filtering results at $(date '+%H:%M:%S')..."

    # Extract and filter domains, then append only new ones
    grep -Eo "([a-zA-Z0-9_-]+\.)+${tar//./\\.}" dns-scan-output.txt 2>/dev/null | \
      grep -viE '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | \
      grep -viE '^(ip6|ip4|v=|include:|spf1|dmarc|_spf|^ns[0-9]|dns[0-9])' | \
      sort -u > tmp-scan-clean.txt

    # Only append new domains not already in clean file
    grep -vxFf dns-scan-clean.txt tmp-scan-clean.txt >> dns-scan-clean.txt

    rm -f tmp-scan-clean.txt
    sleep 300  # Wait 5 minutes
  done

  # Final pass after dnscan completes
  echo "[*] Final filtering pass..."
  grep -Eo "([a-zA-Z0-9_-]+\.)+${tar//./\\.}" dns-scan-output.txt | \
    grep -viE '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | \
    grep -viE '^(ip6|ip4|v=|include:|spf1|dmarc|_spf|^ns[0-9]|dns[0-9])' | \
    sort -u > tmp-scan-clean.txt

  grep -vxFf dns-scan-clean.txt tmp-scan-clean.txt >> dns-scan-clean.txt
  rm -f tmp-scan-clean.txt

  echo "[+] DNS scan complete. Live results saved to: dns-scan-clean.txt"
}


dnsXscan
dnsScan

