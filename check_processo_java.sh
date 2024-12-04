#!/bin/bash


ps faux | grep -i <nome-processo> | grep java | awk '{print $2}' > /tmp/<nome-processo>.pid

if test -s /tmp/<nome-processo>; then
        #echo 0:"SERVICO UP"
        echo "0:$?:OK"
else
      /opt/pentaho/<path-servico>/pentaho.sh
      echo "1:$?:ERROR"
fi
