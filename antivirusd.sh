#!/bin/bash

dir="$1"
malicious_dir="$2"
interval="$3"

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi

if [ ! -d "$dir" ]; then
    echo "Error: directory '$dir' does not exist."
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then
    mkdir -p "$malicious_dir"
fi

malicious_extensions=(".exe" ".bat" ".vbs" ".scr" ".ps1")
malicious_keywords=("virus" "trojan" "malware" "worm" "ransomware")

last_snapshot="directory-info.last"
new_snapshot="directory-info.new"

scan_directory() {
    for file in "$dir"/*; do
        [ -f "$file" ] || continue

        filename=$(basename "$file")
        malicious=false

        extension=".${filename##*.}"

        for bad_extension in "${malicious_extensions[@]}"; do
            if [ "$extension" = "$bad_extension" ]; then
                malicious=true
                break
            fi
        done

        if [ "$malicious" = false ]; then
            for keyword in "${malicious_keywords[@]}"; do
                if grep -qiF "$keyword" "$file" 2>/dev/null; then
                    malicious=true
                    break
                fi
            done
        fi

        if [ "$malicious" = true ]; then
            echo "$file is malicious and it is DELETED"
            cp -- "$file" "$malicious_dir/$filename"
            rm -- "$file"
        fi
    done
}

if [ ! -f "$last_snapshot" ]; then
    scan_directory
    ls -l "$dir" > "$last_snapshot"
fi

while true; do
    sleep "$interval"

    ls -l "$dir" > "$new_snapshot"

    if ! cmp -s "$last_snapshot" "$new_snapshot"; then
        scan_directory
        cp "$new_snapshot" "$last_snapshot"
    fi
done
