#!/bin/bash

join -a1 -a2 <(sed s/^Exe/00ne/ GHJ1.txt | sort) <(sed s/^Exe/00ne/ GHJ2.txt | sort) | column -t | sed s/^00ne/Exe/