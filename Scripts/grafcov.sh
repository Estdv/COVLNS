#!/bin/bash


mkdir graficas

if [ $1 = v ]
    then
    for FILE in *.results/; 
    do cd $FILE;
    Rscript /home/laboratorionacional/Documents/COVLNS/Scripts/plot_cov.R
    mv Rplots.pdf "${FILE::4}grafica.pdf"
    cp "${FILE::4}grafica.pdf" ../graficas;
    cd ..

    done;

elif [ $1=h ]
    then
    for FILE in */; 
    do cd $FILE;
    samtools depth -o depth.tsv "${FILE::4}_sorted.bam"
    Rscript /home/laboratorionacional/Documents/COVLNS/Scripts/plot_cov.R
    mv Rplots.pdf "${FILE::4}grafica.pdf"
    cp "${FILE::4}grafica.pdf" ../graficas;
    cd ..

    done;

fi

cd graficas;
pdfunite *.pdf ../GraficasCovertura.pdf;
cd ..;
rm -r graficas;



