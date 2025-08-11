#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.sudhaaru676.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run theis script with root access"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end


dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disable current MYSQL version"

cp mysql.repo /etc/yum.repos.d/mysql.repo

VALIDATE $? "Copied MYSQL repo"

dnf install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? " Enabling MYSQL Server" 

systemctl start mysqld &>> $LOGFILE

VALIDATE $? " starting MYSQL Server" 

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? " setting MYSQL root password" 
