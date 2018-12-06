#!/bin/bash
# build and pack a rust lambda library
# https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/

set -euo pipefail
mkdir -p target/lambda
export CARGO_TARGET_DIR=$PWD/target/lambda
(
    if [[ $# -gt 0 ]]; then
        yum install -y "$@"
    fi
    # source cargo
    . $HOME/.cargo/env
    cargo build ${CARGO_FLAGS:-} --release
) 1>&2
cd "$CARGO_TARGET_DIR"/release
(
    for file in $(
      find -maxdepth 1 -executable -type f
    ); do
        strip "$file"
    done
) 1>&2