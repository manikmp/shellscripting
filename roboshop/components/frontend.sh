#!/usr/bin/env bash

source components/common.sh

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
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
statcheck $?

print "starting nginx"

systemctl restart nginx

statcheck $?











