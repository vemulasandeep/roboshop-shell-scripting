#!/usr/bin/env bash
yum install golang -y
useradd roboshop
curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip
rm -rf dispatch
unzip /tmp/dispatch.zip
mv dispatch-main dispatch
cd dispatch
go mod init dispatch
go get
go build