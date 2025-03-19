#!/bin/bash

find . -maxdepth 1 -type f -name '*.sh' -print0 | while IFS= read -r -d '' bash_script; do
    result=''
    if bash "$bash_script"; then
        result='OK'
    else
        result='FAIL'
    fi
    echo "$bash_script: $result"
done