#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

command="${1:?Missing command}"
CATEGORIES_FILE="${2:-CHART_CATEGORIES}"

if [[ -f "$CATEGORIES_FILE" ]]; then
    allowed_categories=($(cat "$CATEGORIES_FILE"))
else
    echo "::set-output name=categories-are-correct::false"
    echo "ERROR: Specified file ${CATEGORIES_FILE} does not exist. Please create the file in your repository and add the list of categories."
    exit 1 # Exit with non-zero code to make the action fail
fi

echo "INFO: Using as allowed categories: ${allowed_categories[@]}"

if [[ "$command" == "check-categories" ]]; then
    modified_charts="$(ct list-changed --config /ct-config.yaml)"

    if [[ "$?" != "0" ]]; then
        echo "::set-output name=categories-are-correct::false"
        echo "ERROR: ct command failed"
        exit 1 # Exit with non-zero code to make the action fail
    fi

    while read -r chart; do
        if [[ "$chart" != "" ]]; then
            echo "Checking '$chart'"
            category=$(yq r "${chart}/Chart.yaml" 'annotations.category')
            if [[ ! "${allowed_categories[@]}" =~ "$category" || -z "$category" ]]; then
                echo "::set-output name=categories-are-correct::false"
                echo "ERROR: Invalid category '${category}' for ${chart}."
                echo "       Allowed categories are: ${allowed_categories[@]}"
                exit 1 # Exit with non-zero code to make the action fail
            fi
        fi
    done <<<"$(echo "$modified_charts" | grep -v ">>>" || true)"

    echo "::set-output name=categories-are-correct::true"
    echo "SUCCEED!!"
fi
