#!/bin/bash

# Define the pattern
# Updated to handle semantic versions with suffixes (like -beta, -alpha, etc.)
GREP_PATTERN='ghcr\.io/lay3rlabs/wavs:(v?[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?|[a-zA-Z0-9-_./]+)'

export DEBUGGING=${DEBUGGING:-false}

main() {
    # declare an empty array
    matches_set=()

    # iterate over all files not ignored by .gitignore
    while read file; do
        if [[ $file == lib/* ]]; then
            continue
        fi
        if [[ $file == *$(basename $0) ]]; then
            continue
        fi

        found_docker=$(grep -P -o "$GREP_PATTERN" $file)
        if [[ ! -z $found_docker ]]; then
            # ensure found_docker is split on new lines to each their own array components (some files may have multiple references)
            IFS=$'\n' read -rd '' -a found_docker_array <<< "$found_docker"
            for i in "${found_docker_array[@]}"; do
                if [[ $DEBUGGING == "true" ]]; then
                    echo "Found in $file: $i"
                fi

                # check if the array already contains the item, if it does, skip adding it
                if [[ " ${matches_set[@]} " =~ " ${i} " ]]; then
                    continue
                fi

                matches_set+=("$i")
            done
        fi
    done < <(git ls-files --cached --others --exclude-standard)

    if [[ ${#matches_set[@]} -eq 1 ]]; then
        echo "Only found a single image: ${matches_set[0]}, success"
        exit 0
    else
        echo "Found multiple docker images in the codebase:"
        for i in "${matches_set[@]}"; do
            echo "$i"
        done
        echo "Please ensure only a single wavs docker image is being referenced in the files"
        exit 1
    fi
}

test_data() {
    # Example test data
    TEST_DATA="
    Running container ghcr.io/lay3rlabs/wavs:0.3.0-beta
    Pulling ghcr.io/lay3rlabs/wavs:latest
    Found ghcr.io/lay3rlabs/wavs:0.1.0
    Invalid: docker.io/other/image:1.0
    Using ghcr.io/lay3rlabs/wavs:sha-abc123
    ghcr.io/lay3rlabs/wavs:rc.1.0.0
    Pulling ghcr.io/lay3rlabs/wavs:latest
    Found ghcr.io/lay3rlabs/wavs:0.1.0
    Invalid: docker.io/other/image:1.0
    Using ghcr.io/lay3rlabs/wavs:sha-abc123
    ghcr.io/lay3rlabs/wavs:rc.1.0.0
    ghcr.io/lay3rlabs/wavs:0.3.0-beta
    ghcr.io/lay3rlabs/wavs:1.0.0-alpha
    "

    # Find all matches_set with line numbers (-n) and print the pattern at the top
    echo "Pattern being used: $GREP_PATTERN"
    echo -e "\nmatches_set found:"
    echo "$TEST_DATA" | grep -P -o "$GREP_PATTERN"
}

# test_data
main
