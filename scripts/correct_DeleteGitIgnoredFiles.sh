#!/bin/bash
was_git=1

if [ ! -d .git ]; then
    was_git=0
    git init
fi

git clean -dfX

if [ $was_git -eq 0 ]; then
    rm -rf .git
fi

