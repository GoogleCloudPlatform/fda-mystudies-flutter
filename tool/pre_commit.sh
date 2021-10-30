#!/bin/bash

find . -name "*.dart" ! -name "*.pb.dart" ! -name "*.pbjson.dart" ! -name "*.pbserver.dart" ! -name "*.pbenum.dart" | xargs dart format --set-exit-if-changed
dart analyze