#!/bin/bash

source=""
destination=""
sourceMethod="sc"
destinationMethod="dr"
# Parse long options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --sc)
            sourceMethod="sc"
            shift
            ;;
        --dr)
            destinationMethod="dr"
            shift
            ;;
        --sd)
            sourceMethod="sd"
            shift
            ;;
        --dk)
            destinationMethod="dk"
            shift
            ;;
        --dd)
            destinationMethod="dd"
            shift
            ;;
        --sw)
            sourceMethod="sw"
            shift
            ;;
        --)
            shift
            break
            ;;
        --*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [[ -z "$source" ]]; then
                source="$1"
            elif [[ -z "$destination" ]]; then
                destination="$1"
            else
                echo "Unknown argument: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ "$sourceMethod" == "sw" ]]; then #swap
    echo "Swapping $source and $destination"
    tmp="/move_files_tmp"
    mkdir "$tmp"
    cp -a "$source"/. "$tmp"
    rm -rf "$source"/*
    cp -a "$destination"/. "$source"
    rm -rf "$destination"/*
    cp -a "$tmp"/. "$destination"
    rm -rf "$tmp"
    exit 0
fi

if [[ "$destinationMethod" == "dr" ]]; then
    cp -a "$source"/. "$destination"
elif [[ "$destinationMethod" == "dk" ]]; then
    cp -n -a "$source"/. "$destination"
elif [[ "$destinationMethod" == "dd" ]]; then
    rm -rf "$destination"/*
    cp -a "$source"/. "$destination"
fi

if [[ "$sourceMethod" == "sd" ]]; then
    rm -rf "$source"/*
fi