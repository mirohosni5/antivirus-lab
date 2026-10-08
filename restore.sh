#!/bin/bash

dir="$1"
malicious_dir="$2"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

if [ ! -d "$dir" ]; then
    echo "Error: directory '$dir' does not exist."
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then
    echo "Error: directory '$malicious_dir' does not exist."
    exit 1
fi

files=()

for file in "$malicious_dir"/*; do
    [ -f "$file" ] || continue
    files+=("$file")
done

if [ "${#files[@]}" -eq 0 ]; then
    echo "No malicious files to review."
    exit 0
fi

while true; do
    files=()

    for file in "$malicious_dir"/*; do
        [ -f "$file" ] || continue
        files+=("$file")
    done

    if [ "${#files[@]}" -eq 0 ]; then
        break
    fi

    echo
    echo "Files in quarantine:"

    for i in "${!files[@]}"; do
        echo "$((i + 1)). $(basename "${files[$i]}")"
    done

    echo

    read -p "Choose a file by number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]; then
        echo "Invalid choice."
        continue
    fi

    selected_file="${files[$((choice - 1))]}"
    filename=$(basename "$selected_file")

    echo
    echo "1. Restore this file"
    echo "2. Permanently delete this file"
    echo "3. Leave this file as-is"

    read -p "Choose an option: " option

    case "$option" in
        1)
            cp -- "$selected_file" "$dir/$filename"
            rm -- "$selected_file"
            echo "Restored $filename to $dir."
            ;;
        2)
            rm -- "$selected_file"
            echo "$filename permanently deleted."
            ;;
        3)
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
