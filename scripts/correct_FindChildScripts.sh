#!/bin/bash

function print_children() {
    parent_pid=$1
    for child_pid in $(pgrep -P "$parent_pid"); do
        child_name=$(ps -p "$child_pid" -o comm= | awk '{print $1}')
        if [[ "$child_name" == *.sh ]]; then
            echo "$child_name"
        fi
        print_children "$child_pid"
    done
}

parent_name="exec.sh"
parent_pid=$(pgrep -x "$parent_name")
print_children "$parent_pid"