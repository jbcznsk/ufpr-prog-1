#!/bin/bash

# Aluno     : Jorge Lucas Vicilli Jabczenski
# Matéria   : Programação 1
# Professor : Albini (Turma D)

#################################################################################
                                ##### ITEM 1 #####
#################################################################################
#Descompacta o arquivo
tar -xzf evasao2014-18.tar.gz

#################################################################################
                                ##### ITEM 2 #####
#################################################################################
#Vai para a pasta descompactada e junta todas as evasões em um arquivo só
cd evasao
cat evasao* > evasao-geral
#################################################################################
                                ##### ITEM 3 #####
#################################################################################
cat evasao-geral | cut -d, -f1 | sort -u > formas
sed -i 's/FORMA_EVASAO//g' formas    # Tira o cabeçalho
sed -i '/^$/d' formas                # Tira a linha em branco

# Cria uma variavel FORMAS com todas as formas de desistência
mapfile -t FORMAS < formas

# Conta as ocorrências de cada forma de desistencia no geral
for i in "${FORMAS[@]}"
do
    j=$(grep "${i}" evasao-geral | wc -l)
    echo "${i}, ${j}" >> ranking-geral   
done

echo -e "[ITEM 3]"

# Rankeia os tipos de evasão gerais
awk '{print $NF,$0}' ranking-geral | sort -nr | cut -f2- -d' ' > ranking-geral-s
echo -e "\nRANKING GERAL"
column -t -s',' ranking-geral-s
#cat ranking-geral-s

#sort -t'/' -k2 -r -n -o ranking-geral ranking-geral
#sed -i 's/\// /g' ranking-geral
#echo -e "RANKING GERAL \n"
#cat ranking-geral

ls *.csv > nome-arquivos
mapfile -t NOMEARQUIVOS < nome-arquivos

for i in ${NOMEARQUIVOS[@]}
do
    for j in "${FORMAS[@]}"
    do
        k=$(grep "${j}" ${i} | wc -l)
        echo "$j , $k" >> "$i-"
    done

    awk '{print $NF,$0}' $i- | sort -nr | cut -f2- -d' ' > $i-s
    echo -e "\nRANKING $i"
    column -t -s',' $i-s
    #cat $i-s
    rm $i- 

done
#################################################################################
                                ##### ITEM 4 #####
#################################################################################

echo -e "\n[ITEM 4]"
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

echo "ALUNOS ANOS" >> permanencia.txt
for i in ${PERMANENCIA[@]}
do 
    z=$(grep $i permanencia | wc -l)
    echo "$z $i" >> permanencia.txt
done

column -t permanencia.txt

#################################################################################
#                                   ITEM 5                                      #
#################################################################################
echo -e "\n[ITEM 5]"

for i in ${NOMEARQUIVOS[@]}
do
    total=$(cat $i | wc -l)   # Conta o total de alunos
    total=$(expr $total - 1)  # Tira a linha de cabeçalho
    sem1=$(grep -c 1o $i)     # Conta a quantidade de evasões no 1 semestre
    sem2=$(grep -c 2o $i)     # Conta a quantidade de evasões no 2 semestre
    
    if [ $sem1 -gt $sem2 ]
    then
        pctg=$(expr $sem1 \* 100 / $total)
        sem="1o"
    else 
        pctg=$(expr $sem2 \* 100 / $total)
        sem="2o"
    fi

    ano=$(echo $i | cut -d'-' -f2 | cut -d'.' -f1)
    echo "$ano semestre $sem - $pctg%" >> porcentagem-semestre
done
column -t porcentagem-semestre

#################################################################################
#                                   ITEM 6                                      #
#################################################################################
echo -e "\n[ITEM 6]\n"

totalpessoas=$(cat evasao-geral | wc -l)  
totalpessoas=$(expr $totalpessoas - 6)  #Tira as linhas de cabeçalho
Masculino=$(grep -wc M evasao-geral)
Feminino=$(grep -wc F evasao-geral)

pctgM=$(expr $Masculino \* 100 / $totalpessoas)
pctgF=$(expr $Feminino \* 100 / $totalpessoas)

echo "SEXO,MÉDIA EVASÕES (5 anos)" > porcentagem-sexo
echo "F,$pctgF%" >> porcentagem-sexo
echo "M,$pctgM%" >> porcentagem-sexo

column -t -s',' porcentagem-sexo
