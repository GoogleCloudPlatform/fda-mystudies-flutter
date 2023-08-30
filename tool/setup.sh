#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"

declare -ar PROJECT_NAMES=(
    "package/fda_mystudies_spec"
    "package/fda_mystudies_http_client"
    "package/fda_mystudies_design_system"
    "package/fda_mystudies_activity_ui_kit"
    "."
)

function ci_projects () {
    local channel="$1"

    shift
    local arr=("$@")
    for PROJECT_NAME in "${arr[@]}"
    do
        echo "== Setup '${PROJECT_NAME}' on $channel channel =="
        pushd "${PROJECT_NAME}"

        # Grab packages.
        flutter pub get

        if [ "${PROJECT_NAME}" == "package/fda_mystudies_http_client" ]
        then
            flutter pub run build_runner build --delete-conflicting-outputs
        fi

        if [ "${PROJECT_NAME}" == "package/fda_mystudies_design_system" ]
        then
            flutter gen-l10n
        fi

        if [ "${PROJECT_NAME}" == "package/fda_mystudies_activity_ui_kit" ]
        then
            flutter pub run build_runner build --delete-conflicting-outputs
        fi

        if [ "${PROJECT_NAME}" == "package/fda_mystudies_spec" ]
        then
            dart pub global activate protoc_plugin
            find . -name "*.proto" | xargs -I {} protoc --dart_out=. "{}"
        fi

        if [ "${PROJECT_NAME}" == "." ]
        then
            flutter gen-l10n
        fi

        popd
    done
}

ci_projects "stable" "${PROJECT_NAMES[@]}"

echo "-- Success --"
