#!/usr/bin/env bash

source components/common.sh

print "download the repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
statcheck $?

print "install the redis"
yum install redis-6.2.7 -y &>>${LOG_FILE}
statcheck $?

