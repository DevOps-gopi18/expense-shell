#!/bin/bash

USERID=$(id -u)

VALIDATION() {
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILED"
        exit 1
    else
        echo "$2...SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "ERROR: You don't have root access to execute the program"
    exit 1
fi

dnf module disable nodejs -y
VALIDATION $? "Disabled the nodejs"

dnf module enable nodejs:20 -y
VALIDATION $? "Enabled the nodejs 20"

dnf install nodejs -y
VALIDATION $? "Install the nodejs"

id expense
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATION $? "creating the user expense"
else
    echo "User already exist"
fi

mkdir -p /app
VALIDATION $? "creating the /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATION $? "downloading the files"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
VALIDATION $? "unzip the files"

npm install
VALIDATION $? "installing dependencies"

cp /root/expense-shell/backend.service /etc/systemd/system/backend.service

dnf install mysql -y
VALIDATION $? "Installing MySQL"

mysql -h 32.197.42.62 -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATION $? "Logging into MySQL server"

systemctl daemon-reload
VALIDATION $? "daemon reload"

systemctl start backend
VALIDATION $? "Start backend"

systemctl enable backend
VALIDATION $? "Enable backend"

systemctl restart backend
VALIDATION $? "Restart backend"
