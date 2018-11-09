#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

docker build \
    -t quay.io/coreos/helm:metering-v2.8.2 \
    -f "$DIR/Dockerfile" \
    "$DIR"
