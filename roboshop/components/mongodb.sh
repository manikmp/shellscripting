#!/usr/bin/env bash

statcheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

print() {
  echo -e "\n--------$1-------" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
   if [ "$USER_ID" -ne 0 ]; then
     echo "you should run your script as sudo (or) root user"
     exit 1
   fi
   LOG_FILE=/tmp/roboshop.log
   rm -f $LOG_FILE

print "setup yum Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statcheck $?

print "Install MONGODB"
yum install -y mongodb-org &>>$LOG_FILE
statcheck $?

print "update MONGODB listen Address"
sed -i -e 'S/127.0.0.1/0.0.0.0/' /etc/Mongod.conf
statcheck $?

print "start MONGODB"
systemctl enable mongodb &>>$LOG_FILE
statcheck $?

