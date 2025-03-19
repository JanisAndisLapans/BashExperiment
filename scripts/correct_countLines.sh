#!/bin/bash

find /usr/files -type f -name "*.txt" -print0 | xargs -0 cat | wc -l