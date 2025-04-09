#!/bin/bash

ps -aux | grep user | awk -F' ' '{print $1}' | sort -u | wc -l