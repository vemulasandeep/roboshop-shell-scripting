#!/usr/bin/env bash
yum install python36 gcc python3-devel -y
useradd roboshop
cd /home/roboshop
rm -rf payment
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip
mv payment-main payment
cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip
mv payment-main payment
cd /home/roboshop/payment
pip3 install -r requirements.txt
