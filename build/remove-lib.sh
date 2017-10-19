#!/bin/bash
set -e

SOURCE_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rm -I -r -v ${SOURCE_SCRIPT_DIR}/../contrib/android-*/$1
