#!bin/bash

echo "exit code: $(journalctl -u myservice.service --no-pager | grep status= | tail -n 1 | awk -F 'status=|/' '{print $2}')"