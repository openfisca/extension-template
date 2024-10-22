#!/bin/bash

readonly ignore_diff_on='README.md CONTRIBUTING.md Makefile .gitignore .github/* .editorconfig .shellcheckrc'
# Check if any file that has not be listed in IGNORE_DIFF_ON has changed since the last tag was published.
readonly excluded=$(echo " ${ignore_diff_on}" | sed 's/ / :(exclude)/g')
# --first-parent ensures we don't follow tags not published in master through an unlikely intermediary merge commit
readonly last_tagged_commit=$(git describe --tags --abbrev=0 --first-parent)

# shellcheck disable=SC2086
if git diff-index --name-only --exit-code ${last_tagged_commit} -- . ${excluded}; then
  echo 'No functional changes detected.'
  exit 1
else
  echo 'The functional files above were changed.'
fi
