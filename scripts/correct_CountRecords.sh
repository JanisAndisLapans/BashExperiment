#!/bin/bash

zcat records.gz | awk -v RS="\*\*\*\*\n" '/Z=2/ && /apples=2/{count++} !/apples=2/{other++} END{print "Final counter value=",count, "; other=", other}'