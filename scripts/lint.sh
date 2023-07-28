#!/bin/bash

set -u
read -a files_to_check <<< "$@"
root_dir="$(git rev-parse --show-toplevel)"
error_files=()
exit_code_sum=0
FORCE=${FORCE:-0}

if [[ "$FORCE" -eq 0 ]] && [[ "${#files_to_check[@]}" -eq 0 ]]; then
    echo "No files provided, set FORCE=1 to lint all files. Skipping linter!"
    exit 0
elif [[ "$FORCE" -eq 1 ]] && [[ "${#files_to_check[@]}" -eq 0 ]]; then
    echo "No files provided but FORCE=1. Will lint all files"
    # Add all files to the array
    while read -r f; do
        files_to_check+=("$f")
    done < <(find . -type f \( -name "*.json" -o -name "*.md" \))
fi

if [[ "${#files_to_check[@]}" -ne 0 ]]; then
    echo "Will check ${#files_to_check[@]} files"
    for f in "${files_to_check[@]}"; do
        if [[ -f "$f" ]]; then
            # Run a different linter depending on file extension
            base_file="$(basename -- "$f")"
            echo "Checking '$base_file'"
            file_extension="${base_file##*.}"
            if [[ "$file_extension" = "json" ]]; then
                jq_request="."
                if [[ "$f" =~ .*\/?config\/components\/.* ]]; then
                    # Check both 'name' key is present and it is a valid JSON file
                    jq_request=".name"
                    output="$(jq --exit-status "$jq_request" "$f")"
                    exit_code=$?
                elif [[ "$f" =~ .*\/?config\/.* ]]; then
                    # Check it is a valid JSON file
                    output="$(jq --exit-status "$jq_request" "$f")"
                    exit_code=$?
                elif [[ "$f" =~ .*\/?data\/.* ]]; then
                    # Check CVE file against OSV schema
                    check-jsonschema --verbose --schemafile "${root_dir}/config/validation/schema.json" "$f"
                    exit_code=$?
                fi
                if [[ $exit_code -ne 0 ]]; then
                    # jq doesn't return any error message if 'name' is not found, just 'null'.
                    # Let the user know about this specific issue
                    if [[ "$output" = "null" ]] && [[ "$jq_request" = ".name" ]]; then
                        echo "error: 'name' key not found"
                    fi
                fi
            elif [[ "$file_extension" = "md" ]]; then
                # MD013: allow long lines in file
                markdownlint --disable=MD013 "$f"
                exit_code=$?
            else
                echo "Skipping '$base_file'"
                continue
            fi
            # Check error code to report errors
            if [[ $exit_code -ne 0 ]]; then
                error_files+=("$(basename "$f")")
            fi
            exit_code_sum=$((exit_code_sum + exit_code))
        fi
    done
fi

if [[ $exit_code_sum -ne 0 ]]; then
    echo "Errors found in the next files: '${error_files[@]}'. Please review them"
    exit 1
fi
exit 0
