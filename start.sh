#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo 'Usage: sh start.sh TASK_NUM TECHNOLOGY' 
    exit 1
fi

if ! [ $2 == "ror" -o $2 == "mg" ]; then
    echo 'TECHNOLOGY must be ror for Ruby on Rails or mg for Angular M'
    echo 'Usage: sh start.sh TASK_NUM TECHNOLOGY'
    exit 1
fi

#check TASK_NUM
#check begin.data file

GITHUB_ACCOUNT=`sh github.account.data`

if [ -z $GITHUB_ACCOUNT ]; then
    echo 'Run setup.sh before starting a task'
    exit 1
fi

echo $GITHUB_ACCOUNT
git clone https://github.com/$GITHUB_ACCOUNT/$2_tasks

if [ $? -eq 0 ]; then
    echo 'Project cloned successfully'
else
    echo 'Project https://github.com/$GITHUB_ACCOUNT/$2_tasks could not be cloned'
fi
