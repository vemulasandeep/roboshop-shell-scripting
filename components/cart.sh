#!/usr/bin/env bash

if [ $USER_ID -ne 0 ]
then
  echo you are not a root user
  echo You can run this script as root user or sudo
  exit 1
fi

curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install

sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart
