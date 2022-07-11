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
  echo -e "\n---------$1-------" &>>LOG_FILE
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
print "Installing Nginx"
yum install nginx -y >>LOG_FILE
statcheck $?
systemctl enable nginx >>LOG_FILE
statcheck $?
systemctl start nginx >>LOG_FILE

print "Downloading nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>LOG_FILE
statcheck $?

print "cleanup old Nginx content"
cd /usr/share/nginx/html
rm -rf * >>LOG_FILE
print "Extracting Archive"
unzip /tmp/frontend.zip >>LOG_FILE && mv frontend-main/* . >>LOG_FILE && mv static/* . >>LOG_FILE
rm -rf frontend-main README.md
statcheck $?
print "Update Roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>LOG_FILE
statcheck $?

print "starting nginx"

systemctl restart nginx

statcheck $?











