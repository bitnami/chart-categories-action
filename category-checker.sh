#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

command=${1:?Missing command}

ALLOWED_CATEGORIES=(
  "Analytics"
  "ApplicationServer"
  "CMS"
  "CRM"
  "CertificateAuthority"
  "Database"
  "DeveloperTools"
  "Forum"
  "HumanResourceManagement"
  "Infrastructure"
  "LogManagement"
  "MachineLearning"
  "ProjectManagement"
  "Wiki"
  "WorkFlow"
  "E-Commerce"
  "E-Learning"
)

if [[ "$command" == "check-categories" ]]; then
  modified_charts=($(ct list-changed --config /ct-config.yaml | grep -v ">>>"))

  if [[ "$?" != "0" ]]; then
    echo "::set-output name=categories-are-correct::false"
    echo "ERROR: ct command failed"
    exit 1 # Exit with non-zero code to make the action fail
  fi

  if [[ ! "${#modified_charts[@]}" -eq 0 ]]; then
    for chart in "${modified_charts[@]}"; do
      category=$(yq r "${chart}/Chart.yaml" 'annotations.category')
      if [[ ! "${ALLOWED_CATEGORIES[@]}" =~ "$category" || -z "$category" ]]; then
        echo "::set-output name=categories-are-correct::false"
        echo "ERROR: Invalid category '${category}' for ${chart}."
        echo "       Allowed categories are: ${ALLOWED_CATEGORIES[@]}"
        exit 1 # Exit with non-zero code to make the action fail
      fi
    done
  fi

  echo "::set-output name=categories-are-correct::true"
  echo "SUCCEED!!"
fi

