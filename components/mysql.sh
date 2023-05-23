#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

if [ -z "${MYSQL_PASSWORD}" ]; then
echo " Need MYSQL_PASSWORD env variable"
exit 1
fi

PRINT "Configure YUM repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
CHECK_STAT $?

PRINT "Install my sql"
yum install mysql-community-server -y &>>${LOG}
CHECK_STAT $?

PRINT "Starting MySQL service"
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
CHECK_STAT $?

MySQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo show databases | mysql -uroot -p"${MYSQL_PASSWORD}" &>>${LOG}
if [ $? -ne 0 ]; then
  PRINT "RESET Root Password"
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}" &>>${LOG}
  CHECK_STAT $?
fi

echo show plugins  | mysql -uroot -p"${MYSQL_PASSWORD}" 2>>${LOG} | grep validate_password &>>${LOG}
if [ $? -eq 0 ]; then
  PRINT "Uninstall Password Validate Plugin"
  echo "uninstall plugin validate_password;" | mysql -uroot -p"${MYSQL_PASSWORD}" &>>${LOG}
  CHECK_STAT $?
fi
