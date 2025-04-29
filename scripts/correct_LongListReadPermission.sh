#!/bin/bash

find . -perm -u=r -type f -exec ls -l {} \;
