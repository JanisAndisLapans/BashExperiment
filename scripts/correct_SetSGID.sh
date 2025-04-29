#!/bin/bash

find "$1"/.sn -mindepth 1 -type d -exec chmod g+s {} \;
