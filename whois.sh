#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

if [ ! -e "$filename" ]; then
    echo "Error: File not found: $filename"
    exit 1
fi

while IFS= read -r domain; do
    echo "Checking availability for $domain..."

    result=$(timeout 5 whois "$domain" | head -n 1 2>/dev/null)

    if [ $? -eq 124 ]; then
        echo "Timeout: Unable to check availability for $domain within 8 seconds."
    else
        if [[ "$result" == *"No match"* ]]; then
            echo "$domain is available"
        else
            echo "$domain is not available."
        fi
    fi

    echo "--------------------------------------------"
done < "$filename"
