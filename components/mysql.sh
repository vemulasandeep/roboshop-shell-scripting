#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

PRINT "Configure YUM repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
CHECK_STAT &?

PRIINT "Install my sql "
yum install mysql-community-server -y &>>${LOG}
CHECK_STAT $?

PRINT "Starting MySQL service"
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
CHECK_STAT $?

MySQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

PRINT "Reset root password"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MySQL_DEFAULT_PASSWORD}"
CHECK_STAT $?

exit