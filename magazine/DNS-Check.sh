#!/bin/bash

dnsx -l vertical-subdomains.txt -all -resp -retry 3 -t 50 -o dnsx_results.txt
