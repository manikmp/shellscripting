#!/usr/bin/env bash

statcheck() {
  if [ $1 -eq o ]; then
    echo -e "\e[32mSUCESS\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
  exit 2
  fi

}

USER_ID=$(id -u)
if [ "USER_ID -ne 0" ];
then
  echo -e "\e[32mSUCESS\e[om"
 else
   echo -e "\e[31mFAILURE\e[om"
  exit 1
fi

echo -e "\e[36m installing nginx \e[0m"
yum install nginx -y
statcheck $?
systemctl enable nginx
systemctl start nginx

echo -e "\e[36m Downloading nginx content \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
statcheck $?

echo -e "\e[36m cleanup old nginx content and extract now downloaded archive \e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

statcheck $?

echo -e "\e[36m starting nginx \e[0m"

systemctl restart nginx
statcheck $?











