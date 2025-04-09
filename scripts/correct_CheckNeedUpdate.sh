#!/bin/bash

apt-get -yqq update
needsUpdate=$(apt-get -sqq upgrade | grep "Inst htop" | wc -l)
if [ $needsUpdate -gt 0 ]; then
    echo "update needed"
else
    echo "update not needed"
fi