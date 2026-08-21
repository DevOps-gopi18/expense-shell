#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo " ERROR: You don't have root access to execute the program"
    exit 1
fi

dnf install mysql-server -y

if [ $? -ne 0 ]
then
    echo "MySQL installation...FAILED"
    exit 1
else
    echo "MySQL installation....SUCCESS"
fi

systemctl enable mysqld
if [ $? -ne 0 ]
then
    echo "unable to load the mysqld service"
    exit 1
else
    echo "MySQL enabled"
fi

systemctl start mysqld
if [ $? -ne 0 ]
then
    echo "unable to load the mysqld service"
    exit 1
else
    echo "MySQL started"
fi

mysql -h 32.197.42.62 -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    echo "MySQL root password not setup"
    mysql_secure_installation --set-root-pass ExpenseApp@1
    if [ $? -ne 0 ]
    then
        echo "FAILED"
        exit 1
    else
        echo "SUCCESS"
    fi
else
    echo "MySQL root password already setup...SKIPPING"
fi