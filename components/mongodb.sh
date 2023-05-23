#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

PRINT "Configure YUM repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
CHECK_STAT $?

PRINT "Install mongodb"
yum install -y mongodb-org &>>${LOG}
CHECK_STAT $?



#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file

#Config file: `/etc/mongod.conf`

#then restart the service

#vim /etc/mongod.conf
PRINT "Configure mongodb service"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
CHECK_STAT $?

PRINT "Start Mongodb"
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>${LOG}
CHECK_STAT $?


## Every Database needs the schema to be loaded for the application to work.
PRINT "Download the schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG}
CHECK_STAT $?

PRINT "Load the Schema"
cd /tmp && unzip -o mongodb.zip &>>${LOG} && cd mongodb-main && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
CHECK_STAT $?

