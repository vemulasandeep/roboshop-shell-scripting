#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

PRINT "Setup YUM rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT "Setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT "Install erlang & Rabbitmq"
yum install erlang  rabbitmq-server -y &>>${LOG}


#systemctl enable rabbitmq-server
#systemctl start rabbitmq-server
#rabbitmqctl add_user roboshop $"{RABBITMQ_USER_PASSWORD}"
#rabbitmqctl set_user_tags roboshop administrator
#rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
