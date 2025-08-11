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

dnf install maven -y

VALIDATE $? "Installing maven"

useradd roboshop

VALIDATE $? "Installing maven"

mkdir -p /app

VALIDATE $? "Installing maven"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VALIDATE $? "Installing maven"

cd /app

unzip -o /tmp/shipping.zip

VALIDATE $? "Installing maven"

mvn clean package

VALIDATE $? "Installing maven"

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "Installing maven"

cp /etc/systemd/system/shipping.service

VALIDATE $? "Installing maven"

systemctl daemon-reload

systemctl enable shipping 

systemctl start shipping 

dnf install mysql -y

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping