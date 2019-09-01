#!/bin/bash

# Aluno     : Jorge Lucas Vicilli Jabczenski
# Matéria   : Programação 1
# Professor : Albini (Turma D)
 
#Descompacta o arquivo
tar -xzf evasao2014-18.tar.gz

#Vai para a pasta descompactada e junta todas as evasões em um arquivo só
cd evasao
cat evasao* > evasao-geral

cat evasao-geral | cut -d, -f1 | sort -u > formas
sed -i 's/FORMA_EVASAO//g' formas    # Tira o cabeçalho
sed -i '/^$/d' formas                # Tira a linha em branco

# Cria uma variavel FORMAS com todas as formas de desistência
mapfile -t FORMAS < formas

# Conta as ocorrências de cada forma de desistencia no geral
for i in "${FORMAS[@]}"
do
    j=$(grep "${i}" evasao-geral | wc -l)
    echo "${i} ${j}" >> ranking-geral   
done

# Rankeia os tipos de evasão gerais
awk '{print $NF,$0}' ranking-geral | sort -nr | cut -f2- -d' ' > ranking-geral-s
cat ranking-geral-s

#sort -t'/' -k2 -r -n -o ranking-geral ranking-geral
#sed -i 's/\// /g' ranking-geral
#echo -e "RANKING GERAL \n"
#cat ranking-geral

