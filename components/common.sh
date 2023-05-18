#!/usr/bin/env bash

CHECK_ROOT() {
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then
  echo you are not a root user
  echo You can run this script as root user or sudo
  exit 1
fi
}