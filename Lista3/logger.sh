#!/bin/bash

logger "Teste do comando logger" -i
MEUPID = $(tail -1 /var/log/syslog | cut -d[ -f2 | cut -d] -f1)
echo "syslog - $MEUPID"
