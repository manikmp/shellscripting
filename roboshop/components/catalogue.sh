#!/usr/bin/env bash

source components/common.sh

print "configure yum repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG_FILE}
statcheck $?

print "install NodeJS"
yum install nodejs -y  &>>$LOG_FILE
statcheck $?

print "ADD APPlication user"
if [ $? -ne 0 ]; then
 useradd ${APP_USER} &>>${LOG_FILE}
 statcheck $?
fi
print "Download App component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
statcheck $?

print "cleanup old contnent"
rm -rf /home/${APP_USER}/catalogue &>>${LOG_FILE}
statcheck $?

print "extract appcontent"
cd /home/${APP_USER} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
statcheck $?

print "Install App Dependencies"
cd /home/${APP_USER}/catalogue &>>${LOG_FILE} && npm install &>>${LOG_FILE}
statcheck $?

print "Fix App user permission"
chown -R ${APP_USER} : ${APP_USER} /home/${APP_USER}
statcheck $?

print "setup systemD file"
sed -i -e 's/MONGO DNS Name/mongodb.roboshop.internal/'/home/roboshop/catalogue/systemd.service  &>>${LOG_FILE}
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>{LOG_FILE}
statcheck $?

print "Restart catalogue service"
systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
statcheck $?



