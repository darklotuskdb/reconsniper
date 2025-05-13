#!/bin/bash

# Run gowitness scan in background (silent)
Screenshots(){
echo "[*] Running gowitness scans in background..."
{
  gowitness scan file -f dns-scan-subdomains.txt --port 443,80 --timeout 4 --write-db
  gowitness scan file -f vertical-subdomains.txt --port 443,80 --timeout 4 --write-db
} &> /dev/null &

# Wait 5 seconds before report
sleep 5
echo "[*] Starting gowitness report server..."
gowitness report server &

# Wait another 5 seconds before opening browser
sleep 5
echo "[*] Opening report in Firefox..."
firefox http://127.0.0.1:7171/ &
}


Httpx_ports(){
# Run httpx and display output to terminal
echo "[*] Starting httpx scan..."

~/go/bin/httpx -l dns-scan-subdomains.txt \
  -timeout 4 \
  -p 53,81,82,83,85,86,88,89,90,99,100,2082,2083,3000,3001,3002,5000,5600,5601,5700,6443,7000,7001,7002,8080,8081,8082,8083,8090,8181,8443,8444,8843,8880,8888,9000,9001,9002,9090,9200,9443,10000,10001,10080,10443,16080 \
  -title -status-code -tech-detect -o httpx_results-non-443-80-custom.txt 
  
  ~/go/bin/httpx -l vertical-subdomains.txt \
  -timeout 4 \
  -p 53,81,82,83,85,86,88,89,90,99,100,2082,2083,3000,3001,3002,5000,5600,5601,5700,6443,7000,7001,7002,8080,8081,8082,8083,8090,8181,8443,8444,8843,8880,8888,9000,9001,9002,9090,9200,9443,10000,10001,10080,10443,16080 \
  -title -status-code -tech-detect -o httpx_results-non-443-80-vertical.txt 
  
}


Screenshots
Httpx_ports
