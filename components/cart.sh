#!/usr/bin/env bash
source components/common.sh
CHECK_ROOT

   echo "setting up nodejs yum repo is"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash &>>${LOG}
CHECK_STAT $?

echo "Installing node js"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

echo "creating application user"
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo "downloading cart content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

echo "removing old content if any exist"
rm -rf cart &>>${LOG}
CHECK_STAT $?

echo "extracting the ZIP content"
unzip /tmp/cart.zip &>>{LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

echo "Installing nodejs dependencies"
npm install &>>${LOG}
CHECK_STAT $?

echo "Update SystemD configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

echo "setup SystemD configurations"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl enable cart

echo "Start user service"
systemctl restart cart &>>$LOG}
CHECK_STAT $?

