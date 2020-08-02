#!/bin/sh

linux=false
mac=true
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    linux=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mac=true
fi

if $mac; then
    echo "MAC"
elif $linux; then
    echo "LINUIX"
fi