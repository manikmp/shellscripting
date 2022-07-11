#!/usr/bin/env bash

statcheck() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCESS\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
  exit 2
  fi
}

print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "USER_ID -ne 0" ];
then
  echo -e "\e[32mSUCESS\e[om"
 else
   echo -e "\e[31mFAILURE\e[om"
  exit 1
fi

print "Installing Nginx"
yum install nginx -y
statcheck $?
systemctl enable nginx
statcheck $?
systemctl start nginx

print "Downloading nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
statcheck $?

print "cleanup old Nginx content"
cd /usr/share/nginx/html
rm -rf *
print "Extracting Archive"
unzip /tmp/frontend.zip && mv frontend-main/* .&& mv static/* .
rm -rf frontend-main README.md
statcheck $?
print "Update Roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
statcheck $?

print "starting nginx"

systemctl restart nginx

statcheck $?











