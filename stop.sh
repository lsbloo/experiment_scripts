#!/bin/bash

CheckParams() {
    if [ "$#" -ne 0 ]; then
        echo 'Usage: stop.sh' 
        exit 1
    fi
}

CheckFile() {
   if [ -f "$1" ]; then
        echo "File $1 found."
    else
        echo "File $1 not found."
        exit 1
    fi
}

CheckContent() {
    if [ -z $1 ]; then
        echo 'Run start.sh before stoping a task'
        exit 1
    fi
}

CheckTask() {
    CheckContent $1

    if [[ $1 = *[[:digit:]]* ]]; then
        if [[ $1 < 1 || $1 > 14 ]]; then
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

RunTests() {
    cd ${1}_tasks
    PID=0

    if [ $1 == "ror" ]; then
        rails server >/dev/null 2>&1 &
        PID=$!
        sleep 5
    else
        ng serve --port 3000 &
        PID=$!
    fi

    SELENIUM_BROWSER=chrome node $3
    TEST_RESULT=$?

    kill -9 $PID  > /dev/null 2>&1

    if [ $TEST_RESULT -eq 0 ]; then
        echo "Tests passed for Task $2"
    else
        echo "Tests failed for Task $2. Please fix them and try again."
        exit 1
    fi
}

SaveEnd() {
    NOW=`date +%s`
    echo "$NOW" > end.data
}

SendFilesToGithub() {
    git add .
    if [ $? -ne 0 ]; then
        echo "Could not add files to git" 
        exit 1
    fi

    git commit -m " Task $1 finished"
    if [ $? -ne 0 ]; then
        echo "Could not commit files on git" 
        exit 1
    fi

    git push origin A$1
    if [ $? -ne 0 ]; then
        echo "Could not push files to Github" 
        exit 1
    fi
}

CleanUp() {
    cd
    rm -rf ~/${1}tasks
    rm technology.data task.data
}

CheckParams
CheckFile task.data
TASK=`sh task.data`
CheckTask $TASK
CheckFile technology.data
TECHNOLOGY=`sh technology.data`
CheckTechnology $TECHNOLOGY
CheckFile github.account.data
GITHUB_ACCOUNT=`sh github.account.data`
RunTests $TECHNOLOGY $TASK test/task-e2e.js
SaveEnd
SendFilesToGithub $TASK
CleanUp $TECHNOLOGY
