#!/bin/bash

find . -name "*.dart" ! -name "*.pb.dart" ! -name "*.pbjson.dart" ! -name "*.pbserver.dart" ! -name "*.pbenum.dart" | xargs flutter format --set-exit-if-changed
flutter analyze
