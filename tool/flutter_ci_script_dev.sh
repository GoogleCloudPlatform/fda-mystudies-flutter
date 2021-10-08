#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"
source "$DIR/flutter_ci_script_shared.sh"

flutter doctor -v

declare -ar PROJECT_NAMES=(
    "."
    "package/fda_mystudies_spec"
)

ci_projects "dev" "${PROJECT_NAMES[@]}"

echo "-- Success --"