#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: You don't have root access to execute the program"
    exit 1
fi

dnf install nginx -y
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl enable nginx
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl start nginx
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

rm -rf /usr/share/nginx/html/*
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

cd /usr/share/nginx/html
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

unzip /tmp/frontend.zip
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

cp /root/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi

systemctl restart nginx
if [ $? -ne 0 ]
then
    echo "FAILED"
    exit 1
else
    echo "SUCCESS"
fi