#!/bin/bash

# Ensure bashdep is installed
[[ ! -f lib/bashdep ]] && {
  mkdir -p lib
  curl -sLo lib/bashdep \
    https://github.com/Chemaclass/bashdep/releases/download/0.1/bashdep
  chmod +x lib/bashdep
}

readonly DEPENDENCIES=(
  "https://github.com/openfisca/openfisca-setup-builder/releases/download/0.1.1/first-time-setup.sh"
)

# Load, configure and run bashdep
# shellcheck disable=SC1091
source lib/bashdep
bashdep::setup dir="." silent=false
bashdep::install "${DEPENDENCIES[@]}"
