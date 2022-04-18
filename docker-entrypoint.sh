#!/bin/bash

source /etc/apache2/envvars

echo "Executing: $*"

cmd=$1
shift
exec "${cmd}" "$@"
