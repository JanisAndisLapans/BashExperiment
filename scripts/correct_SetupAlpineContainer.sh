#!/bin/bash

systemctl start docker

docker run -d --name alpine-linux-container -v /usr/alpinedata:/imported --init alpine:latest sleep inf