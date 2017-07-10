#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo 'Usage: setup.sh github_account your@email.com "Your Name"'
    exit 1
fi

sh ~/experiment_scripts/update.sh

echo "echo $1" | xargs > github.account.data
git config --global user.email "$2"
git config --global user.name "$3"

echo "Virtual machine configured."
