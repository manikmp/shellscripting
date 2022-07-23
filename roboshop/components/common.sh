#!/usr/bin/env bash

statcheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCESS\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
  exit 1
  fi
}

print() {
  echo -e "\n---------$1-------" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "USER_ID -ne 0" ];
then
  echo -e "\e[32mSUCESS\e[om"
 else
   echo -e "\e[31mFAILURE\e[om"
  exit 2
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE


APP_USER=roboshop

NODEJS() {

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
curl -f -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>${LOG_FILE}
statcheck $?

print "extracting the app content"
cd /home/${APP_USER} &>>${LOG_FILE} && rm -rf ${component} &>>${LOG_FILE} && unzip -o /tmp/${component}.zip  &>>${LOG_FILE}  && mv  ${component}-main  ${component} &>>${LOG_FILE}
statcheck $?

print "Install app dependencies"
cd /home/${APP_USER}/${component} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
statcheck $?

print "Fix App User Permission"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
statcheck $?

print "set up the systemd file"
if [ -f /home/roboshop/${component}/systemd.service ]; then
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE}
fi
statcheck $?
if [ -f /home/roboshop/${component}/systemd.service ]; then
 sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE}
fi
statcheck $?
if [ -f /home/roboshop/${component}/systemd.service ]; then
   sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE}
fi
statcheck $?
if [ -f /home/roboshop/${components}/systemd.service ]; then
   sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE}
fi
statcheck $?
mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG_FILE}
statcheck $?

print "Restarting the user service"
systemctl daemon-reload &>>${LOG_FILE} && systemctl start ${component} &>>${LOG_FILE}  &&  systemctl enable ${component} &>>${LOG_FILE}
statcheck $?
}