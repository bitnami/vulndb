#!/bin/bash

set -u
errorFiles=()
exitCodeSum=0

while read -r f; do
    echo "Checking '$(basename "$f")'"
    jq . "$f" > /dev/null
    exitCode=$?
    if [ $exitCode -ne 0 ]; then
        errorFiles+=("$(basename "$f")")
    fi
    exitCodeSum=$((exitCodeSum + exitCode))
done < <(find . -type f -name "*.json")

if [ $exitCodeSum -ne 0 ]; then
    echo "Errors found in the next files: '${errorFiles[@]}'. Please review them"
    exit 1
fi
exit 0
