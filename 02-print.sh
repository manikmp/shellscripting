#!/usr/bin/env bash

echo Hello World

## color codes
# Red       31
# green     32
# Yellow    33
# Blue      34
# Magenta   35
# Cyan      36

# Syntax : echo -e "\e[31mHello\[0m"
echo -e "\e[1;33;4;44m yellow underlined text on Blue Background\e[0m"
echo -e "\e[33m brown text\e[1m"
