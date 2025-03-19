#!/bin/bash

if [ -e archive.tar ]; then
    tar -xf archive.tar
elif [ -e archive.zip ]; then
    unzip archive.zip
elif [ -e archive.tar.gz ]; then
    tar -xzvf archive.tar.gz
elif [ -e archive.bz2 ]; then
    bunzip2 archive.bz2
elif [ -e archive.gz ]; then
    gunzip archive.gz
elif [ -e archive.xz ]; then
    unxz archive.xz
elif [ -e archive.7z ]; then
    7z x archive.7z
fi