#!/usr/bin/env bash

CHECK_ROOT() {
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then
  echo -e "\e[33m You should be running this script as root user or sudo the script \e[0m "
    exit 1
fi
}

CHECK_STAT() {
echo --------------------------- >>${LOG}
if [ $1 -ne 0 ]; then
  echo -e "\e[31mFAILED\e[0m"
  echo -e "\n check log file - ${LOG} for errors\n"
  exit 2
  else
  echo -e "\e[32m SUCCESS\e[0m"
  fi

}
LOG=/tmp/roboshop.log
rm -rf $LOG

PRINT() {
echo ------------ $1 ------------ >>${LOG}
echo "$1"
}

NODEJS {
source components/common.sh
CHECK_ROOT

  PRINT "setting up nodejs yum repo is"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT  "Installing node js"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT  "creating application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ]
then
    useradd roboshop &>>${LOG}
fi
CHECK_STAT $?

PRINT "downloading cart content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

PRINT  "removing old content if any exist"
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT "extracting the ZIP content"
unzip /tmp/cart.zip &>>{LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

PRINT  "Installing nodejs dependencies"
npm install &>>${LOG}
CHECK_STAT $?

PRINT  "Update SystemD configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT  "setup SystemD configurations"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable cart

PRINT  "Start user service"
systemctl restart cart &>>$LOG}
CHECK_STAT $?



}