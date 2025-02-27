#!/bin/bash
startingDir=$(git branch | grep \*)

if [[ $startingDir != *"develop"* ]]; then
    git stash
fi

git checkout develop
git fetch origin
git merge -X ours origin/develop


