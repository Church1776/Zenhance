#!/bin/bash

# Custom config .bashrc for brass in MSYS environments.
# 
# This file is intedned to localize your msys & wsl profiles to the msys directory.
# Add your custom configurations below this line.

# Grab the default bashrc from the system. This gives us a base to build on, and ensures we have all the standard MSYS features available.
source /etc/bash.bashrc

PS1="\[\e]0;\w\a\]\[\e[32m\]\u@\h\[\e[0m\]:\[\e[35m\]$MSYSTEM\[\e[0m\]\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ "