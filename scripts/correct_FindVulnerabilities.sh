#!/bin/bash

vulnerability_cnt=0
vulnerability_codes=""
while IFS= read -r code; do
    vulnerability_codes="$vulnerability_codes $code"
    ((vulnerability_cnt++))
done < <(trivy fs --severity HIGH,CRITICAL . | tr '\n' ' ' | grep -oE 'CVE[0-9/-]+')

if ((vulnerability_cnt != 0)); then
    echo "Here are the vulnerabilities: $vulnerability_codes"
else
    echo "The project is clean"
fi