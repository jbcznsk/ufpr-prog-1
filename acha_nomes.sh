#!/bin/bash

cd /home/bcc
finger * | grep Name | cut -f4 | cut -d' ' -f2 | sort -u > /tmp/nomes_de_informatas.txt
cd ~
mv /tmp/nomes_de_informatas.txt .

