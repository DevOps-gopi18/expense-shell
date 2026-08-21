#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: You don't have root access to execute the program"
    exit 1
fi

dnf module disable nodejs -y
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

dnf module enable nodejs:20 -y
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

dnf install nodejs -y
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

id expense
if [ $? -ne 0 ]
then
    useradd expense
    if [ $? -ne 0 ]
    then
        echo "FAILED"
        exit 1
        else
            echo "SUCCESS"
        fi
else
    echo "User already exist"
fi

mkdir -p /app
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

npm install
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

cp /root/expense-shell/backend.service /etc/systemd/system/backend.service

dnf install mysql -y
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

mysql -h 32.197.42.62 -uroot -pExpenseApp@1 < /app/schema/backend.sql
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl daemon-reload
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl start backend
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl enable backend
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl restart backend
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi
