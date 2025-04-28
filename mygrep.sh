#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "  -n       Show line numbers for each match"
    echo "  -v       Invert the match (print lines that do not match)"
    echo "  --help   Display this help message"
    exit 1
}

# Check for help flag
if [[ "$1" == "--help" ]]; then
    usage
fi

# Initialize variables
show_line_numbers=false
invert_match=false
search_string=""
filename=""

# Parse command-line options
while getopts ":nv" opt; do
    case ${opt} in
        n) show_line_numbers=true ;;
        v) invert_match=true ;;
        \?) 
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

# Shift positional parameters to get search string and filename
shift $((OPTIND - 1))
search_string="$1"
filename="$2"

# Validate input
if [[ -z "$search_string" ]]; then
    echo "Error: Missing search string." >&2
    usage
fi

if [[ -z "$filename" ]]; then
    echo "Error: Missing filename." >&2
    usage
fi

# Check if the specified file exists
if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' not found." >&2
    exit 1
fi

# Construct the grep command based on options
grep_command="grep -i"
if $invert_match; then
    grep_command+=" -v"
fi

# Execute the grep command with or without line numbers
if $show_line_numbers; then
    $grep_command -n "$search_string" "$filename"
else
    $grep_command "$search_string" "$filename"
fi
