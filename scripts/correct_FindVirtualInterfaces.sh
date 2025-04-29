#!/bin/bash

virtualInterfacesFound=0
for interface in $(ls -l /sys/class/net/ | grep virtual | grep -v total | grep -v lo | awk '{print $9}'); do
    running=$(ifconfig | grep "$interface:" | wc -l)
    if [ $running -eq 0 ]; then
        continue
    fi

    ipv4=$(ifconfig "$interface" | grep -Eo 'inet [0-9.]+' | awk '{print $2}')
    if [ -z "$ipv4" ]; then
        ipv4='None'
    fi
    echo "$interface - $ipv4"
    virtualInterfacesFound=$((virtualInterfacesFound + 1))
done

if [ $virtualInterfacesFound -eq 0 ]; then
    echo "No virtual interfaces found"
fi