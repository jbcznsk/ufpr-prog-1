#!/bin/bash

# Aluno     : Jorge Lucas Vicilli Jabczenski
# Matéria   : Programação 1
# Professor : Albini (Turma D)

#################################################################################
#                                     ITEM 1                                    #
#################################################################################

tar -xzf evasao2014-18.tar.gz      #Descompacta o arquivo

#################################################################################
#                                     ITEM 2                                    #
#################################################################################

cd evasao                    # Vai para a pasta descompactada 
cat evasao* > evasao-geral   # Junta todas as evasões em um arquivo só

#################################################################################
#                                     ITEM 3                                    #
#################################################################################

echo -e "[ITEM 3]" > saida-geral

cat evasao-geral | cut -d',' -f1 | sort -u > formas # Acha todas as formas de evasão
sed -i 's/FORMA_EVASAO//g' formas                   # Tira o cabeçalho
sed -i '/^$/d' formas                               # Tira a linha em branco

# Cria uma variavel FORMAS com todas as formas de desistência
mapfile -t FORMAS < formas

# Conta as ocorrências de cada forma de desistencia no geral
for i in "${FORMAS[@]}"
do
    j=$(grep "${i}" evasao-geral | wc -l)
    echo "${i}, ${j}" >> ranking-geral   
done

# Rankeia os tipos de evasão gerais
awk '{print $NF,$0}' ranking-geral | sort -nr | cut -f2- -d' ' > ranking-geral-s
echo -e "\nRANKING GERAL" >> saida-geral

column -t -s',' ranking-geral-s >> saida-geral

ls *.csv > nome-arquivos                 # Obtém os nomes de todos os arquivos que contém as evasões
mapfile -t NOMEARQUIVOS < nome-arquivos  # Cria uma variável com esses nomes

# Faz a mesma coisa que o ranking geral, mas agora para todos os arquivos
for i in ${NOMEARQUIVOS[@]}
do
    for j in "${FORMAS[@]}"
    do
        k=$(grep "${j}" ${i} | wc -l)
        echo "$j , $k" >> "$i-"
    done

    awk '{print $NF,$0}' $i- | sort -nr | cut -f2- -d' ' > $i-s
    echo -e "\nRANKING $i" >> saida-geral
    column -t -s',' $i-s >> saida-geral
    rm $i- 
done

#################################################################################
#                                     ITEM 4                                    #
#################################################################################

echo -e "\n[ITEM 4]" >> saida-geral
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

column -t permanencia.txt >> saida-geral

#################################################################################
#                                   ITEM 5                                      #
#################################################################################

echo -e "\n[ITEM 5]" >> saida-geral

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

column -t porcentagem-semestre >> saida-geral

#################################################################################
#                                   ITEM 6                                      #
#################################################################################

echo -e "\n[ITEM 6]\n" >> saida-geral

totalpessoas=$(cat evasao-geral | wc -l)  
totalpessoas=$(expr $totalpessoas - 6)  #Tira as linhas de cabeçalho
Masculino=$(grep -wc M evasao-geral)
Feminino=$(grep -wc F evasao-geral)

pctgM=$(expr $Masculino \* 100 / $totalpessoas)
pctgF=$(expr $Feminino \* 100 / $totalpessoas)

echo "SEXO,MÉDIA EVASÕES (5 anos)" > porcentagem-sexo
echo "F,$pctgF%" >> porcentagem-sexo
echo "M,$pctgM%" >> porcentagem-sexo

column -t -s',' porcentagem-sexo >> saida-geral

#################################################################################
#                                   ITEM 7                                      #
#################################################################################

for i in {2014..2018}
do
    NR_EVASOES=$(cat evasao-$i.csv | wc -l)
    NR_EVASOES=$(expr $NR_EVASOES - 1)       #Tira a linha do cabeçalho
    echo "$i $NR_EVASOES" >> grafico-nr-evasoes
done

gnuplot -persist <<-FimDeComando

    set output 'evasoes-ano.png'
    set terminal png
    set key above
    set title 'Nr° de Evasões por Ano'
    set xlabel "Anos"
    set ylabel "Nr° de Evasões"

    plot 'grafico-nr-evasoes' with lines title 'Evasões'


FimDeComando

mv evasoes-ano.png ..

#################################################################################
#                                   ITEM 8                                      #
#################################################################################

for i in ${NOMEARQUIVOS[@]}
do
    cat $i | cut -d',' -f3 >> formas-ingresso     # Obtém todas as formas possíveis de ingresso
done

cat formas-ingresso | sort -u > formas-ingresso-s # Retira as formas repetidas
sed -i 's/FORMA_INGRESSO//g' formas-ingresso-s    # Tira o cabeçalho
sed -i '/^$/d' formas-ingresso-s                  # Tira a linha em branco

mapfile -t FORMAS_INGRESSO < formas-ingresso-s    # Insere todas as formas em um vetor

for i in {2014..2018}
do
    echo -n "$i " >> grafico-final
    for j in "${FORMAS_INGRESSO[@]}" 
    do
        NR=$(grep -c "$j" evasao-$i.csv)
        echo -n "$NR " >> grafico-final
    done
    echo >> grafico-final
done

gnuplot -persist <<-FimDeComando

    set output 'evasoes-forma.png'
    set terminal png
    set title '[ITEM 8]'
    set style data histogram
    set style histogram cluster gap 1
    set style fill solid
    set boxwidth 0.8
    set xtics format
    set yrange[0:180]

    plot 'grafico-final'\
    using 2:xtic(1) title 'Aluno Intercâmbio',\
    '' using 3         title 'Aproveitamento Curso Superior',\
    '' using 4         title 'Convênio AUGM',\
    '' using 5         title 'Convênio Pec-G',\
    '' using 6         title 'Mobilidade Acadêmica',\
    '' using 7         title 'Processo Seletivo/Enem',\
    '' using 8         title 'Reopção',\
    '' using 9         title 'Transferência Ex-Ofício',\
    '' using 10        title 'Transferência Provar',\
    '' using 11        title 'Vestibular',\


FimDeComando

mv evasoes-forma.png ..
mv saida-geral ..
cd ..
rm -r evasao
cat saida-geral 