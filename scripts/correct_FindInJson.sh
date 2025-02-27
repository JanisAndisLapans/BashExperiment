#!/bin/bash

users=()

# Find all files in the current directory
for file in *; do
    if [ ! -f "$file" ]; then
        continue
    fi
    curly_braces=0
    potential_json=""
    # Iterate characters
    while IFS= read -r -n1 c || [ -n "$c" ]; do
        if ((curly_braces > 0)); then
            potential_json="$potential_json$c"
        else
            potential_json=""
        fi

        if [[ "$c" == "{" ]]; then
            curly_braces=$((curly_braces + 1))
            if ((curly_braces == 1)); then
                potential_json="$c"
            fi
        elif [[ "$c" == "}" ]] && ((curly_braces > 0)); then
            curly_braces=$((curly_braces - 1))
            if ((curly_braces == 0)); then
                # Check if the potential JSON is valid
                echo "$potential_json" | jq -e . >/dev/null 2>&1
                status=${PIPESTATUS[1]}
                if [[ "$status" == "0" ]] ; then
                    pattern='"user":\s*"(.*?)"'
                    while read -r match; do
                        if [[ "$match" =~ $pattern ]]; then
                            user="${BASH_REMATCH[1]}"
                            users+=("$user")
                        fi
                    done < <(echo "$potential_json" | grep -oP "$pattern")
                fi
                potential_json=""
            fi
        fi
    done <"$file"
done

if ((${#users[@]} == 0)); then
    echo "No users found"
else
    output="Here are the users: "
    i=1
    # Temporarily set IFS to newline to avoid word splitting when reading array elements
    OLDIFS=$IFS
    IFS=$'\n'
    sorted_users=($(for user in "${users[@]}"; do echo "$user"; done | sort))
    # Restore IFS
    IFS=$OLDIFS
    for user in "${sorted_users[@]}"; do
        output="$output$user"
        if [ "$i" -ne ${#sorted_users[@]} ]; then
            output="$output, "
        fi
        i=$((i + 1))
    done
    echo "$output"
fi