#!/bin/bash

FILENAME=$(echo $0 | cut -d/ -f2 | cut -d. -f1)
#FILENAME=$BASH_SOURCE
ARG1=$1
ARG2=$2

echo "Nome do arquivo: $FILENAME"
echo "ARGUMENTOS: $ARG1 e $ARG2"
