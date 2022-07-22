#!/usr/bin/env bash

source components/common.sh

print "configure yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -&>>${LOG_FILE}
statcheck $?

print "install node Js"
 yum install nodejs gcc-c++  -y &>>${LOG_FILE}
 statcheck $?

 print "add application user"
 id ${APP_USER} &>>${LOG_FILE}
 if [ $? -ne 0 ]; then
    useradd ${APP_USER} &>>${LOG_FILE}
 fi
  statcheck $?

 print "Download App Component"
 curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
statcheck $?

print "cleanup old content"
rm -rf /home/${APP_USER}/catalogue  &>>${LOG_FILE}
statcheck $?

print "Extract App Content"
 cd /home/${APP_USER} &>>${LOG_FILE}  && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
 statcheck $?

 print "install App Dependencies"
 cd /home/${APP_USER}/catalogue &>>${LOG_FILE}  && npm install &>>${LOG_FILE}
 statcheck $?

 print "Fix App user Permission"
 chown -R ${APP_USER}:${APP_USER}  /home/${APP_USER}
 statcheck $?

