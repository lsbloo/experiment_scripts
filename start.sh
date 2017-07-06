#!/bin/bash

CheckTaskRange() {
    if [[ $1 = *[[:digit:]]* ]]; then
        if [[ $1 < 0 || $1 > 14 ]]; then
            echo "TASK is $1 but should be between 1 and 14"
            exit 1
        fi
    else
        echo "TASK $1 should be an integer"
        exit 1
    fi
}

CheckTechnology() {
    if ! [ $1 == "ror" -o $1 == "mg" ]; then
        echo 'TECHNOLOGY must be ror for Ruby on Rails or mg for Angular M'
        echo 'Usage: sh start.sh TASK_NUM TECHNOLOGY'
        exit 1
    fi
}

CheckParams() {
    if [ "$1" -ne 2 ]; then
        echo 'Usage: start.sh TASK_NUM TECHNOLOGY' 
        exit 1
    fi

    CheckTaskRange $2
    CheckTechnology $3
}

CheckFile() {
    if [ -f "$1" ]; then
        echo "File $1 found."
    else
        echo "File $1 not found."
        exit 1
    fi
}

StoreData() {
    echo "echo $1" | xargs > $2
}

CloneRepository() {
    GITHUB_ACCOUNT=`sh github.account.data`

    if [ -z $GITHUB_ACCOUNT ]; then
        echo 'Run setup.sh before starting a task'
        exit 1
    fi

    git clone https://github.com/$GITHUB_ACCOUNT/$1

    if [ $? -eq 0 ]; then
        echo "Repository https://github.com/$GITHUB_ACCOUNT/$1 cloned successfully"
    else
        echo "Repository https://github.com/$GITHUB_ACCOUNT/$1 could not be cloned"
        exit 1
    fi

    cd $1
}

HardResetToTag() {
    git reset --hard $1

    if [ $? -eq 0 ]; then
        echo "Code moved to Task $1 successfully"
    else
        echo "Code could not be moved to Task $1"
        exit 1
    fi
}

UpdateDeps() {
    if [ $1 -eq "mg" ]; then
        yarn install
    else
        bundle install
    fi    
}

NewBranch() {
    git checkout -b $1
}

SaveBegin() {
    NOW=`date +%s`
    echo "$NOW" > begin.data
}

CheckParams $# $1 $2
CheckFile github.account.data
StoreData $1 task.data
StoreData $2 technology.data
CloneRepository ${2}tasks
HardResetToTag T$1
UpdateDeps $2
NewBranch A$1
SaveBegin
