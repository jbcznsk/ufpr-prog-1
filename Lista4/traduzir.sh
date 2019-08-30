#/bin/bash
sed -i 's/j/ /g' $1
sed -i 's/p/0/g' $1
sed -i 's/a/1/g' $1
sed -i 's/b/2/g' $1
sed -i 's/c/3/g' $1
sed -i 's/d/4/g' $1
sed -i 's/e/5/g' $1
sed -i 's/f/6/g' $1
sed -i 's/g/7/g' $1
sed -i 's/h/8/g' $1
sed -i 's/i/9/g' $1
sed -i 's/)/ /g' $1
sed -i ':a;$!N;s/\n//;ta;' $1

for i in {1..372} ; do
	
	ISSO=$(cat $1 | cut -d' ' -f$i) 	
	printf \\$(printf "%o" $ISSO) >> oiprof  
		#echo $i
done

sed -i 's/http/\nhttp/g' oiprof
sed -i 's/milenio201/\nmilenio201\n/g' oiprof
sed -i 's/dbsq/\ndbsq/g' oiprof
cat oiprof > $1
#rm oiprof
cat $1
