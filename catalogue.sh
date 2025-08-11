#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGFILE

VALIDATE $? "Copied MongoDB Repo"

dnf module disable nodejs -y &>> LOGFILE

VALIDATE $? "Disable current NodeJS"

dnf module enable nodejs:18 -y &>> LOGFILE

VALIDATE  $? "Enabling NodeJS:18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? " Installing NodeJs:18"

id roboshop 
if [ $? -ne 0 ]
then 
    useradd roboshop  &>> $LOGFILE
    VALIDATE $? " roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi 

mkdir -p /app &>> $LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading catalogue application"

cd /app

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue" 

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies" 

# use absolute, beacuse catalogue.service exists there
cp /home/centos/roboshop-shell1/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue daemon-reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? " Enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/roboshop-shell1/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copyitng mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalogue data into MongoDB"