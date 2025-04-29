#!/bin/bash

users=$(journalctl _COMM=sudo --since today | grep "auth could not identify password" | cut -d " " -f 13 | sed 's/^.\(.*\).$/\1/')
users="$users $(journalctl _COMM=su --since today | grep "authentication failure" | grep -Eo "\buser=\w+" | cut -d "=" -f2)"
users="$users $(journalctl _COMM=login --since today | grep "authentication failure" | grep -Eo "\buser=\w+" | cut -d "=" -f2)"
users="$users $(journalctl _COMM=sshd --since today | grep "Failed password" | cut -d " " -f 9)"

declare -A user_attempts
attempts_over_threshold=0

for user in $users; do
    if [[ -n "${user_attempts[$user]}" ]]; then
        user_attempts[$user]=$((user_attempts[$user] + 1))
        if [[ ${user_attempts[$user]} -eq 3 ]]; then
            attempts_over_threshold=$((attempts_over_threshold + 1))
        fi
    else
        user_attempts[$user]=1
    fi
done

echo "Users: $attempts_over_threshold"