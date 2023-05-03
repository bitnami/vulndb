#!/bin/bash

set -u
errorFiles=()
exitCodeSum=0

while read -r f; do
    # Check both 'name' key is present and it is a valid JSON file
    echo "Checking '$(basename "$f")'"
    output="$(jq --exit-status ".name" "$f")"
    exitCode=$?
    if [ $exitCode -ne 0 ]; then
        errorFiles+=("$(basename "$f")")
        # jq doesn't return any error message if 'name' is not found, just 'null'.
        # Let the user know about this specific issue
        if [ "$output" = "null" ] ; then
            echo "error: 'name' key not found"
        fi
    fi
    exitCodeSum=$((exitCodeSum + exitCode))
done < <(find . -type f -name "*.json")

if [ $exitCodeSum -ne 0 ]; then
    echo "Errors found in the next files: '${errorFiles[@]}'. Please review them"
    exit 1
fi
exit 0
