#!/bin/bash
#-----------------------------------------------------------------------------------------------
# COVLNS

# Programa Principal para analisis de variantes de SASR-COV-2 a partir de datos de secuenciacion
# generados en el Laboratorio Nacional de Salud

# Autor: Esteban Del Valle

# USAGE: bash COVLNS.sh [path] [mode]
#      : bash COVLNS.sh [mode] (corre en directorio actual)

# path: Directorio en donde se encuentran los archivos fastq
# mode: [(H,h):HAVoC,(V,v):Viralflow,(G,g):Gencom] software de variantes utilizado (default: h)

# ex: bash COVLNS.sh /home/fastqs/ h

#File list

   # grafcov.sh
   # pcsv.sh
   # plot_cov.R
   # QCsequence
   # GencomMod
   # Reference files (7)
   # ART_adapters.fa

# Requerimientos:

   # Viralflow y todos sus requerimientos
      # Consultar https://github.com/dezordi/ViralFlow para requerimientos
   # HAVoC y todos los requerimientos
      # Consultar https://bitbucket.org/auto_cov_pipeline/havoc/src/master/ para requerimientos
   # Gencom y todas sus dependencias
      # Consultar 
   # Docker
   # Samtools
   # pdfunite
   # fastqc
   # multiqc
   # R

# ----------------------------------------------------------------------------------------------


echo ""
echo "==================================================="
echo "|   _____ ______      __     _      _   _  _____  |" 
echo "|  / ____/ __ \ \    / /    | |    | \ | |/ ____| |"
echo "| | |   | |  | \ \  / /_____| |    |  \| | (___   |"
echo "| | |   | |  | |\ \/ /______| |    | .   |\___ \  |"
echo "| | |___| |__| | \  /       | |____| |\  |____) | |"
echo "|  \_____\____/   \/        |______|_| \_|_____/  |"
echo "|                                                 |"
echo "==================================================="                                                  
echo ""
echo $2

#variable de opcion y de directorio
#DIRECTORIO ACTUAL DEFAULT
OP=""
DIR="./"

#Recibir argumentos
#en primer lugar, el path o H, G o V para havoc, Gencom o viralflow
#en segundo lugar H, G o V para havoc, Gencom o viralflow

if [ ! -z "$2" ]
then

   if [ -d "$1" ]
   then 
      DIR=$1

   else
      echo "Path invalido. trabajando en folder actual"
      DIR=$PWD
   fi


   if [ $2 = "H" ] || [ $2 = "h" ]
      then
      OP="H"

   elif [ $2 = "v" ] || [ $2 = "V" ]  
      then
      OP="V"

   elif [ $2 = "g" ] || [ $2 = "G" ]  
      then
      OP="G"

   else
   echo "Opcion no valida. Terminando"
   exit

   fi

else
   
   echo "No se proporciono un path. Se utilizara el directorio actual"
         if [ $1="H" ] || [ $1="h" ]
            then
            OP="H"

         elif [ $1 = "v" ] || [ $1 = "V" ]  
            then
            OP="V"

         elif [ $1 = "g" ] || [ $1 = "G" ]  
            then
            OP="G"


         else
            echo "Opcion no valida. Terminando"
            exit


         fi
      DIR=$PWD

   
fi

#control de calidad con fastqc y multiqc
############ RUN QCSECUENCE ###############
cd $DIR
QCsequence


### ABRIR EL ARCHIVO MUTLIQC
firefox $DIR/multiqc_report.html


### Preguntar al usuario que revise el archivo y borre las lecturas que no pasan el filtro
echo ""
echo "-------------------------------------------------------------------"
echo "Revise el archivo MultiQC y borre las secuencias que desee"

echo "Presione 'y' para confirmar y continuar. Presione 'n' para cancelar"
echo "-------------------------------------------------------------------"
### WAIT for input

read  -n 1 -p "Ingrese su respuesta:" mainmenuinput
echo "-------------------------------------------------------------------"
echo ""

x=1

while [ $x == 1 ]
           do

                 if [ $mainmenuinput == "Y" ]  || [ $mainmenuinput == "y" ]
                    then
                    x=2
                    echo "CONTINUANDO"
                    echo ""
            

                 elif [ $mainmenuinput == "N" ]  || [ $mainmenuinput == "n" ]
                    then
                    x=2
                    echo "Saliendo"
                    exit

                 else
                    echo "Entrada invalida. Ingrese y o n para proseguir"
                    echo "Revise el archivo MultiQC y borre las secuencias que desee"
                    echo "Presione 'y' para confirmar y continuar. Presione 'n' para cancelar"
                    echo ""
                    read  -n 1 -p "Ingrese su Respuesta:" mainmenuinput
                    echo "-------------------------------------------------------------------"
                 fi

           done  




echo "Proceeding..."
echo ""

####DECIDE IF VIRALFLOW O HAVoC

if [ $OP = "V" ]
   then
   echo "RUNNING VIRALFLOW"
   #### IF VIRALFLOW

   #### COPY ADAPTERS AND REF FILES #####
   cp ~/Documents/COVLNS/Refs/* ./


   ####create .conf
   cat > args.conf << EOF  
run
inputDir ./
referenceGenome reference.fasta
adaptersFile ART_adapters.fa
totalCpus 2
depth 5 
minLen 75 
containerImg viralflow_container:latest
minDpIntrahost 100 
trimLen 0 
cpusPerSample 1

EOF


   #### BUILD DOCKER
   viralflow --build -containerService docker

   #### RUN VIRALFOW IN DOCKER
   viralflow --runContainer -containerService docker -inArgsFile args.conf

   sudo chmod 777 *.results
   bash grafcov.sh v


#### OPCION HAVoC
elif [ $OP = "H" ]
   then
   echo "-------------"
   echo "Running HAVoC"
   echo "-------------"
   echo ""


   # Llamar al ejecutable de havoc con el directorio provisto
   bash /home/laboratorionacional/auto_cov_pipeline-havoc-e1b9b2be490a/HAVoC.sh $DIR
   echo ""
   echo "-------------------------------"
   echo "Generando graficos de covertura"
   echo "..."
   #Realizar graficas de covertura llamando a grafcov.sh
   bash grafcov.sh h
   echo "Graficos de covertura generados"
   echo "-------------------------------"



elif [ $OP = "G" ]
   then
   echo "-------------"
   echo "Running Gencom"
   echo "-------------"
   echo ""
   bash ~/Documents/COVLNS/GencomMod/gencom_beta.v2-4.sh $DIR



else
   echo "OPCION INVALIDA"
   echo "COVLNS [path] [method]"
   exit
fi





#### FILTRAR a partir de graficas de covertura

#### Abrir PDF de graficas de covertura
if [ $OP == "H" ]  || [ $OP == "V" ]
   then
   xdg-open $DIR/GraficasCovertura.pdf

else
xdg-open $DIR/analysis/coverage/individualdepth_plot.png

fi

echo ""
echo "-------------------------------------------------------------------"
echo "Revise el archivo de graficas de covertura y borre las secuencias que desee"

echo "Presione 'y' para confirmar y continuar. Presione 'n' para cancelar"
echo "-------------------------------------------------------------------"
### WAIT for input

read  -n 1 -p "Ingrese su respuesta:" mainmenuinputecho "-------------------------------"
echo "-------------------------------------------------------------------"
echo ""
### WAIT for input

x=1

while [ $x == 1 ]
           do

                 if [ $mainmenuinput == "Y" ]  || [ $mainmenuinput == "y" ]
                    then
                    x=2
                    echo "YES CONTINUE"
                    echo ""
            

                 elif [ $mainmenuinput == "N" ]  || [ $mainmenuinput == "n" ]
                    then
                    x=2
                    echo "EXIT"
                    exit

                 else
                    echo "Entrada invalida. Ingrese y o n para proseguir"
                    echo "Revise el archivo MultiQC y borre las secuencias que desee"
                    echo "Presione 'y' para confirmar y continuar. Presione 'n' para cancelar"
                    read  -n 1 -p "Input Selection:" mainmenuinput
                 fi

           done



echo ""
echo "proceeding..."
echo""


if [ $OP = "V" ]
   then
   #### CLEAN CSV REMOVE MINORS
   echo "run vf"
   bash pcsv.sh v


#### OPCION HAVoC
elif [ $OP = "H" ]
   then
   #unir csvs de pangolin llamando a pcsv.sh para havoc
   bash pcsv.sh h


fi


#=========================================#

#### Clean and order

#### Order csv.

echo ""
echo "=================="
echo "PROCESO FINALIZADO"
echo "=================="


