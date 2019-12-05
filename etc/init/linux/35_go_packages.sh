##!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

if ! has "gotcha"; then
    # With go command
    if has "go"; then
        log_echo "Install gotcha command form go get!"
        if [ -z "${GOPATH:-}" ]; then
            export GOPATH=$HOME
        fi
        go get -u github.com/b4b4r07/gotcha
    else
         log_fail "error: require: go"
         exit 1
    fi
fi

# Append the GOPATH/bin to the PATH
if [ -x "${GOPATH%%:*}"/bin/gotcha ]; then
    PATH="${GOPATH%%:*}/bin:$PATH"
    export PATH
fi

# It should be able to use Gotcha command if its installation is success
if has "gotcha"; then
    log_echo "Grab go packages"
    gotcha --verbose "$DOTPATH"/etc/init/assets/go/config.toml
else
    log_fail "error: gotcha: not found"
    exit 1
fi

log_pass "Gotcha!"
