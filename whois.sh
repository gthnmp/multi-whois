#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <wordlist_file>"
  exit 1
fi

wordlist="$1"

if [ ! -f "$wordlist" ]; then
  echo "Error: Wordlist file not found."
  exit 1
fi

while read -r word; do
  if [ -z "$word" ]; then
    continue  
  fi

  # Check if the word contains a dot (indicating it has an extension)
  if [[ $word == *.* ]]; then
    domains=("$word")
  else
    # Automatically add .com, .net, and .ai extensions
    domains=("$word.com" "$word.net" "$word.ai")
  fi

  for domain in "${domains[@]}"; do
    result=$(timeout 8 whois "$domain" | grep -E 'No match for|AVAILABLE|Not found|Domain not found|is available for purchase')
    if [ -n "$result" ]; then
      echo "Domain '$domain' is available."
    else
      echo "Domain '$domain' is not available."
    fi
  done
done < "$wordlist"
