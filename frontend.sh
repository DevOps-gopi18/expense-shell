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

dnf install nginx -y
VALIDATION $? "Installing Nginx"

systemctl enable nginx
VALIDATION $? "Enable nginx"

systemctl start nginx
VALIDATION $? "Start nginx"

rm -rf /usr/share/nginx/html/*
VALIDATION $? "Removing deafult html content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATION $? "Downloading files"

cd /usr/share/nginx/html
VALIDATION $? "Navigating to nginx path"

unzip /tmp/frontend.zip
VALIDATION $? "unzip files"

cp /root/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATION $? "Copying config file"

systemctl restart nginx
VALIDATION $? "Restarting nginx"