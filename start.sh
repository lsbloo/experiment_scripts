#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo 'Usage: sh start.sh TASK_NUM TECHNOLOGY' 
    exit 1
fi

if [[ $1 = *[[:digit:]]* ]]; then
    if [[ $1 < 1 || $1 > 14 ]]; then
        echo "TASK is $1 but should be between 1 and 14"
        exit 1
    fi
else
    echo "TASK $1 should be an integer"
    exit 1
fi

if ! [ $2 == "ror" -o $2 == "mg" ]; then
    echo 'TECHNOLOGY must be ror for Ruby on Rails or mg for Angular M'
    echo 'Usage: sh start.sh TASK_NUM TECHNOLOGY'
    exit 1
fi

GITHUB_ACCOUNT=`sh github.account.data`

if [ -z $GITHUB_ACCOUNT ]; then
    echo 'Run setup.sh before starting a task'
    exit 1
fi

git clone https://github.com/$GITHUB_ACCOUNT/$2_tasks

if [ $? -eq 0 ]; then
    echo "Repository https://github.com/$GITHUB_ACCOUNT/$2_tasks cloned successfully"
else
    echo "Repository https://github.com/$GITHUB_ACCOUNT/$2_tasks could not be cloned"
    exit 1
fi

cd $2_tasks

git reset --hard T$1

if [ $? -eq 0 ]; then
    echo "Code moved to Task $1 successfully"
else
    echo "Code could not be moved to Task $1"
    exit 1
fi

git checkout -b A$1

echo `date +%s` > begin.data
