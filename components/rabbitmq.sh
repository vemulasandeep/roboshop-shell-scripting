#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

if [ -z "$RABBITMQ_USER_PASSWORD" ]; then
echo "Env variable password required"
exit 1
fi

PRINT "Setup YUM rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT "Setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT "Installing erlang & Rabbitmq"
yum install erlang  rabbitmq-server -y &>>${LOG}
CHECK_STAT $?

PRINT "Start rabbitmq server"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server
CHECK_STAT $?

rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
    PRINT "create rabbitmq user"
    rabbitmqctl add_user roboshop $"{RABBITMQ_USER_PASSWORD}" &>>${LOG}
    CHECK_STAT $?
fi

PRINT "Rabbitmq user tags and permissions"

rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
CHECK_STAT $?

