#!/bin/bash

MWlist() {
    echo "[*] Extracting base words from subdomains..."
    awk -F'.' '
    {
        for (i = 1; i <= NF; i++) {
            if (length($i) > 1 && $i !~ /^[0-9]+$/) print $i
        }
    }' vertical-subdomains.txt | \
    grep -vE '^(com|net|org|co.uk)$' | \
    sort -u > base_words.txt

    echo "[*] Generating wordlist with permutations, suffixes, and numbers..."
    cp base_words.txt Master_wordlist.txt

    # Define common suffixes/prefixes
    common_terms=(dev test stage staging stg uat beta preprod backup old prod demo)

    # Add numeric suffixes to base words
    while read word; do
        for n in $(seq -w 1 5); do
            echo "${word}${n}"
        done
    done < base_words.txt >> Master_wordlist.txt

    # Add suffixes (word-dev, word-test)
    for suffix in "${common_terms[@]}"; do
        while read word; do
            echo "${word}-${suffix}"
            for n in $(seq -w 1 5); do
                echo "${word}-${suffix}${n}"
            done
        done < base_words.txt
    done >> Master_wordlist.txt

    # Add prefix combinations (dev-word, test-word)
    for prefix in "${common_terms[@]}"; do
        while read word; do
            echo "${prefix}-${word}"
            for n in $(seq -w 1 5); do
                echo "${prefix}-${word}${n}"
            done
        done < base_words.txt
    done >> Master_wordlist.txt

    # Add two-word permutations (loginportal, login-portal)
    while read word1; do
        while read word2; do
            if [[ "$word1" != "$word2" ]]; then
                echo "${word1}${word2}"
                echo "${word1}-${word2}"
            fi
        done < base_words.txt
    done < base_words.txt >> Master_wordlist.txt

    # Final cleanup
    sort -u Master_wordlist.txt -o Master_wordlist.txt
    rm -f base_words.txt
    echo "[*] Master wordlist created: Master_wordlist.txt"
}


MWlist
