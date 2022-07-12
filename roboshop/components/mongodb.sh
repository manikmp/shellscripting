#!/usr/bin/env bash

source components/common.sh

print "setup yum Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statcheck $?

print "Install MONGODB"
yum install -y mongodb-org &>>$LOG_FILE
statcheck $?

print "update MONGODB listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statcheck $?

print "start MONGODB"
systemctl enable mongod &>>$LOG_FILE && systemctl restart mongod &>>$LOG_FILE
statcheck $?

print "Download Schema"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
statcheck $?

print "Extract Schema"
cd /tmp && unzip mongodb.zip &>>$LOG_FILE
statcheck $?

print "Load Schema"
cd mongodb-main && mongo < catalogue.js &>>$LOG_FILE
mongo < users.js &>>$LOG_FILE
statcheck $?

