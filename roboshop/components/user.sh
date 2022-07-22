#!/usr/bin/env bash

source components/common.sh

print "Download the node source file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG_FILE}
statcheck $?

print "Installing the node js"
yum install nodejs -y  &>>${LOG_FILE}
statcheck $?

print "ADD Application User"
id ${APP_USER} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
   useradd ${APP_USER} &>>${LOG_FILE}
fi
statcheck $?

print "Download the App content"
curl -f -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
statcheck $?

print "extracting the app content"
cd /home/${APP_USER} &>>{LOG_FILE} && unzip -o  /tmp/user.zip &>>{LOG_FILE} && mv user-main user &>>{LOG_FILE}
statcheck $?

print "Install app dependencies"
cd /home/${APP_USER}/user &>>${LOG_FILE} && npm install &>>${LOG_FILE}
statcheck $?