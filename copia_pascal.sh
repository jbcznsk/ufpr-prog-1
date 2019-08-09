#!/bin/bash

pushd ~
mkdir pascal2c
find . -name "*.pas" -exec cp {} pascal2c/ \;
ls pascal2c | wc -w > qntd_de_programas
var=$(cat qntd_de_programas)
printf 'Voce copiou %s programas!\n ' "$var"
rm qntd_de_programas
popd