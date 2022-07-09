#!/usr/bin/env bash

if [ ! -e components/$1.sh];then
  echo component does not exist
  exit 1
  fi



bash components/$1.sh

