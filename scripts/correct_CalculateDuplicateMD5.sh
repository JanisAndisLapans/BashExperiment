#!/bin/bash

md5sum /usr/code/*.py | awk '{print $1}' | sort | uniq -d