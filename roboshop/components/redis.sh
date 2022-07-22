#!/usr/bin/env bash

source components/common.sh

print "download the repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
statcheck $?

print "install the redis"
yum install redis-6.2.7 -y &>>${LOG_FILE}
statcheck $?

print "update the redis configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
statcheck $?
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>${LOG_FILE}
statcheck $?

print "starting the redis"
systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>{LOG_FILE}
statcheck $?

