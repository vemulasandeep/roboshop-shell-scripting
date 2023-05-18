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
if [ $1 -ne 0 ]; then
  echo -e "\e[31mFailed\e[0m"
  exit 2
  else
  echo -e "\e[32m Success\e[0m"
  fi

}
LOG=/tmp/roboshop.log
rm -rf $LOG