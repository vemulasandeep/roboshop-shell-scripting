#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT
PRINT "Install Yum repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}

PRINT "Install redis"
yum install redis-6.2.11 -y &>>${LOG}
#
# 2. Update the `bind` from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`


PRINT "Update configure file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}

PRINT "Statrt service file"
systemctl enable redis && systemctl start redis
