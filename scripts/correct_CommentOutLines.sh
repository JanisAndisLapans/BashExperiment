#!/bin/bash

sed -i -E 's/(^[^ \t#][^ \t]*$)/#\1/g' settings.env