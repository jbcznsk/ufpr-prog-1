#!/bin/bash

# Aluno     : Jorge Lucas Vicilli Jabczenski
# Matéria   : Programação 1
# Professor : Albini (Turma D)

                                ##### ITEM 1 #####
#Descompacta o arquivo
tar -xzf evasao2014-18.tar.gz

                                ##### ITEM 2 #####
#Vai para a pasta descompactada e junta todas as evasões em um arquivo só
cd evasao
cat evasao* > evasao-geral
                                ##### ITEM 3 #####
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

echo -e "[ITEM 3]"

# Rankeia os tipos de evasão gerais
awk '{print $NF,$0}' ranking-geral | sort -nr | cut -f2- -d' ' > ranking-geral-s
echo -e "\nRANKING GERAL"
cat ranking-geral-s

#sort -t'/' -k2 -r -n -o ranking-geral ranking-geral
#sed -i 's/\// /g' ranking-geral
#echo -e "RANKING GERAL \n"
#cat ranking-geral

ls *.csv > nome-arquivos
mapfile -t NOMEARQUIVOS < nome-arquivos

#for i in {4..8}
#do
#    for j in "${FORMAS[@]}"
#    do
#        k=$(grep "${j}" evasao-201$i.csv | wc -l)
#        echo "$j $k" >> e$i
#    done
#
#    awk '{print $NF,$0}' e$i | sort -nr | cut -f2- -d' ' > evasao-201$i-s
#    echo -e "\nRANKING 201$i"
#    cat evasao-201$i-s 
#
#done

for i in ${NOMEARQUIVOS[@]}
do
    for j in "${FORMAS[@]}"
    do
        k=$(grep "${j}" ${i} | wc -l)
        echo "$j $k" >> "$i-"
    done

    awk '{print $NF,$0}' $i- | sort -nr | cut -f2- -d' ' > $i-s
    echo -e "\nRANKING $i"
    cat $i-s
    rm $i- 

done

                                ##### ITEM 4 #####

echo -e "\n[ITEM 4]\n"
for i in {2014..2018};
do
    cat evasao-$i.csv | cut -d, -f4 > anos
    sed -i 's/ANO_INGRESSO//g' anos      # Tira cabeçalho
    sed -i '/^$/d' anos                  # Tira a linha em branco

    mapfile -t ANOS < anos

    for j in ${ANOS[@]}
    do
        let P=i-j
        echo $P >> permanencia
    done
done

cat permanencia | sort -un > permanencia-s
mapfile -t PERMANENCIA < permanencia-s
rm permanencia-s

echo "ALUNOS     ANOS"
for i in ${PERMANENCIA[@]}
do 
    z=$(grep $i permanencia | wc -l)
    echo "$z          $i"
done




