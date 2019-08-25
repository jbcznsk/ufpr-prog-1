#!/bin/bash

URL=$1
NOMENOVO=$2
wget $URL
IMAGEM=$(grep og:image index.html | cut -d'"' -f4)
echo "A URL DA IMAGEM EH $IMAGEM"

wget $IMAGEM
NOMEANTIGO=$(grep og:image index.html| cut -d'"' -f4 | cut -d/ -f9)
rm index.html
mv $NOMEANTIGO $NOMENOVO.png
