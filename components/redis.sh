#!/usr/bin/env bash
if [ $USER_ID -ne 0 ]
then
  echo you are not a root user
  echo You can run this script as root user or sudo
  exit 1
fi
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.11 -y
#
# 2. Update the `bind` from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
systemctl enable redis
systemctl start redis
