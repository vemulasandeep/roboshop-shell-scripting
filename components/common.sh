#!/usr/bin/env bash

CHECK_ROOT() {
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then
  echo -e "\e[33m You should be running this script as root user or sudo the script \e[0m "
    exit 1
fi
}