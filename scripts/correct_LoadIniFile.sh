#!/bin/bash

source <(grep = settings.ini | grep -E -v '^[;#\[]' | sed 's/ *= */=/g')