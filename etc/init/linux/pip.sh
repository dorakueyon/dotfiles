#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

## The script is dependent on python
#if ! has "python"; then
#    log_fail "error: require: python"
#    exit 1
#fi


