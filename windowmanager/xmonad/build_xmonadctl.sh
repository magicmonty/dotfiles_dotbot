#!/usr/bin/env sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
pushd $SCRIPT_DIR
ghc -dynamic xmonadctl.hs
popd
