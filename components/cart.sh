#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

  PRINT "setting up nodejs yum repo is"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT  "Installing node js"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT  "creating application user"
useradd roboshop &>>${LOG}
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

