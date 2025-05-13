#!/bin/bash

MWlist() {
    echo "[*] Extracting base words from subdomains..."

    # Extract base keywords from subdomains, skipping common TLDs
    awk -F'.' '
    {
        for (i = 1; i <= NF; i++) {
            if (length($i) > 1 && $i !~ /^[0-9]+$/) print $i
        }
    }' vertical-subdomains.txt | \
    grep -vE '^(com|net|org|co\.uk)$' | \
    sort -u > base_words.txt

    echo "[*] Injecting common terms..."
    # Add useful common environment/function keywords
    common_terms=(dev test prod stage staging stg uat beta pre preprod old backup int qa demo portal api cdn edge static internal admin new store shop web)
    printf "%s\n" "${common_terms[@]}" >> base_words.txt
    sort -u base_words.txt -o base_words.txt

    echo "[*] Generating permutations and combinations..."
    > Master_wordlist.txt  # Empty output file first

    # Base word + numbers (with and without zero padding)
    while read word; do
        for n in $(seq 1 4); do
            echo "${word}${n}"
            printf "%s%02d\n" "$word" "$n"
        done
    done < base_words.txt >> Master_wordlist.txt

    # base-suffix and base-suffix1/base-suffix01
    for suffix in "${common_terms[@]}"; do
        while read word; do
            echo "${word}-${suffix}"
            for n in $(seq 1 4); do
                echo "${word}-${suffix}${n}"
                printf "%s-%s%02d\n" "$word" "$suffix" "$n"
            done
        done < base_words.txt
    done >> Master_wordlist.txt

    # prefix-base and prefix-base1/prefix-base01
    for prefix in "${common_terms[@]}"; do
        while read word; do
            echo "${prefix}-${word}"
            for n in $(seq 1 4); do
                echo "${prefix}-${word}${n}"
                printf "%s-%s%02d\n" "$prefix" "$word" "$n"
            done
        done < base_words.txt
    done >> Master_wordlist.txt

    # Two-word combos: word1word2 and word1-word2
    while read word1; do
        while read word2; do
            if [[ "$word1" != "$word2" ]]; then
                echo "${word1}${word2}"
                echo "${word1}-${word2}"
            fi
        done < base_words.txt
    done < base_words.txt >> Master_wordlist.txt

    echo "[*] Finalizing list..."
    sort -u Master_wordlist.txt -o Master_wordlist.txt
#    rm -f base_words.txt

    echo "[+] Wordlist ready: Master_wordlist.txt"

    echo "[*] Extracting exact base words from subdomains..."
    awk -F'.' '{for(i=1;i<=NF;i++) print $i}' vertical-subdomains.txt | \
    grep -vE '^(com|net|org|co.uk)$' | \
    sort -u > exact_keywords.txt

    echo "[*] Filtering Master_wordlist.txt..."
    # Keep only entries NOT matching exact base keywords
    grep -vxFf exact_keywords.txt Master_wordlist.txt | sort -u > filtered-Master_wordlist.txt

    echo "[+] Cleaned wordlist saved to: filtered-Master_wordlist.txt"
    rm -f exact_keywords.txt
}

MWlist
