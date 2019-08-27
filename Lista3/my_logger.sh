#!/bin/bash

KERNEL=$1
DIR=$2
DATA=$(date +%d-%m-%y)
CLASSIF=("info" "warn" "error")

mkdir tmp

#Se o diretório não existe, cria ele
if [ ! -d ~/$DIR ]; then 
	mkdir ~/$DIR
fi

for i in ${CLASSIF[*]} 
do
	grep -w "$i" $KERNEL  > ./tmp/${DATA}_"$i".log
done

tar -czf ~/$DIR/logs.tar.gz ./tmp/*

if [ -f ~/$DIR/logs.tar.gz ]; then
	logger sucess creating logs.tar.gz	
else
	logger ERROR creating logs.tar.gz
fi

rm -r ./tmp 
