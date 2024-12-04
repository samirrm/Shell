#!/bin/bash

ps faux | grep $1 | grep -v grep | grep java | awk '{print $2}' > /tmp/$1.pid
  
if test -s /tmp/$1.pid; then
    echo "0:$?:OK"
    :>/tmp/$1.pid
  else
    echo "1:$?:ERROR"
fi
