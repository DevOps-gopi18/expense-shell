#!/bin/bash

USERID=$(id -u)

VALIDATION(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILED"
        exit 1
    else
        echo "$2....SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
then
    echo " ERROR: You don't have root access to execute the program"
    exit 1
fi

dnf install mysql-server -y
VALIDATION $? "Installing MySQL server"


systemctl enable mysqld
VALIDATION $? "Enabled the mysqld"

systemctl start mysqld
VALIDATION $? "Started the mysqld"

mysql -h 34.231.241.168 -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    echo "MySQL root password not setup"
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATION $? "Setting up the root password"
else
    echo "MySQL root password already setup...SKIPPING"
fi