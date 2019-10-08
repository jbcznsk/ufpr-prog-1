#!/bin/bash


# Data 25/08/2019
# Para usar, o comando é o seguinte: 
# ./baixaimagem.sh <link da foto no instagram> <nome da foto>
# ex: ./baixaimagem.sh https://www.instagram.com/p/By6GDYupeka/ lily


URL=$1
NOMENOVO=$2
wget $URL
IMAGEM=$(grep og:image index.html | cut -d'"' -f4)
wget $IMAGEM
NOMEANTIGO=$(grep og:image index.html| cut -d'"' -f4 | cut -d/ -f9)
rm index.html
mv $NOMEANTIGO $NOMENOVO.png
mv $NOMENOVO.png ~/Imagens
