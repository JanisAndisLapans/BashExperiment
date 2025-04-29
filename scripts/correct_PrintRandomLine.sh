#!/bin/bash

cat /dev/urandom | tr -dc '01' | fold -w 75 | head -1
