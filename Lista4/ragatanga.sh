#!/bin/bash

FILE=$1

function lerLinhas()
{
    while read line
    do
        re='^[0-9]$'
        for word in $line
        do  
            if [[ $word =~ $re ]] 
            then
                awk 'BEGIN{printf "%c",'$word'}' >> saida
            else
                printf $word >> saida
            fi
        done
        echo >> saida
    done    
}

LETRAS=(p a b c d e f h i)

sed -i 's/j//g' $FILE  

for i in {0..9}
do
    sed -i 's/${LETRAS[$i]}/$i/g' $FILE
done

lerLinhas < $FILE
