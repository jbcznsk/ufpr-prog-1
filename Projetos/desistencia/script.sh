#!/bin/bash

#Descompacta o arquivo
tar -xzf evasao2014-18.tar.gz

#Vai para a pasta descompactada e junta todas as evasões em um arquivo só
mv evasao
cat evasao* > evasao_geral

#Conta as ocorrências de cada forma de desistencia
FORMASDES=("Abandono" "Cancelamento Pedido" "Descumprimento Edital" "Desistência" "Formatura" "Não Confirmação de Vaga" "Novo Vestibular" "Reopção" "Término de Registo Temporário" "Jubilamento") 

for i in ${FORMASDES[*]}
do
    
    a=&(grep $i evasao-geral | cut -d',' -f1 | wc -w)
    echo -e "$i <$a>"    


done
