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
