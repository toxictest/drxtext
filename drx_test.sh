#!/bin/bash
# Check if both reference file and directory are provided as arguments
if [ $# -ne 2 ]; then
    output_figlet=$(figlet -c Script  Written by DrX)
    echo "\033[0;032m ${output_figlet}"
    echo "#################################################################"
    echo "##### THIS IS THE SCRIPT OF TXT Line Finder AUTOMATION ##########"
    echo "#################################################################"
    echo "Usage: $0 <reference_file> <directory>"
    exit 1
fi
reference_file=$1
directory=$2
# Check if the reference file exists
if [ ! -f "$reference_file" ]; then
    echo "Reference file '$reference_file' not found."
    exit 1
fi
# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory '$directory' not found."
    exit 1
fi
# Loop through each line in the reference file
while IFS= read -r line; do
    line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')  # Trim leading and trailing whitespaces
    if [ -n "$line" ]; then
        found_in_files=()
        # Loop through each text file in the directory
        for file in "$directory"/*.txt; do
            if [ -f "$file" ]; then
                if grep -q "$line" "$file"; then
                    found_in_files+=("$(basename "$file")")
                fi
            fi
        done
        # If line found in more than one file, write to output file
        if [ ${#found_in_files[@]} -ge 2 ]; then
            echo "Line: '$line' found in files: ${found_in_files[@]}" >> output.txt
        fi
    fi
done < "$reference_file"
