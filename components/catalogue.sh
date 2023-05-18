#!/usr/bin/env bash
CHECK_ROOT
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y
useradd roboshop

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
rm -rf catalogue
unzip /tmp/catalogue.zip
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

#1. Update SystemD file with correct IP addresses

  #  Update `MONGO_DNSNAME` with MongoDB Server IP

#2. Now, lets set up the service with systemctl.
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue

