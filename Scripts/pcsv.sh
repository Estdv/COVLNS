#!/bin/bash

mkdir pangolin_results

if [ $1 = v ]
    then
    for FILE in *.results/; 
    do cd $FILE; 
    cp *.all.fa.pango.csv ../pangolin_results;
    cd ..;
    done;

elif [ $1=h ]
    then
    for FILE in */;
    do cd $FILE
    cp *.csv ../pangolin_results;
    cd ..
    done


fi

cd pangolin_results;
awk 'FNR==1 && NR!=1{next;}{print}' *.csv >> ../resultados_linaje.csv;
cd ..;
rm -r pangolin_results;





