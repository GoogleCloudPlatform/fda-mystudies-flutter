#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"
source "$DIR/flutter_ci_script_shared.sh"

flutter doctor -v

declare -ar PROJECT_NAMES=(
    "package/fda_mystudies_spec"
    "package/fda_mystudies_http_client"
    "package/fda_mystudies_design_system"
    "package/fda_mystudies_activity_ui_kit"
    "."
)

ci_projects "stable" "${PROJECT_NAMES[@]}"

echo "-- Success --"
