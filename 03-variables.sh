#!/usr/bin/env bash

a=100
b=devops

echo $a times
echo ${b}training

DATE=2022-03-10
echo today date is $DATE

DATE=$(date +%F)
echo today date is $DATE

x=10
y=10
ADD=$(( ${x} + ${y} ))
echo Add = $ADD

c=(10 20 small large)
echo first value of Array  = ${c[0]}
echo second value of Array = ${c[2]}
echo All Values of Array   = ${c[*]}

echo training = ${training}





