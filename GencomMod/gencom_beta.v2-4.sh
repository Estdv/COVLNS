#bin/bash



#Copyright Alexander A. Martinez C & Gorgas Memorial Institute for Health Studies
#Written by: Alexander A. Martinez C, Genomics and proteomics research unit, Gorgas memorial #Institute For Health Studies.
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use
#this work except in compliance with the License. You may obtain a copy of the
#License at:
#http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed
#under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#CONDITIONS OF ANY KIND, either express or implied. See the License for the
#specific language governing permissions and limitations under the License.
 

#########################################
#Modified by Esteban Del Valle
#SARS-COV-2 specific in LNS, Guatemala
#########################################


#This software uses diferent smart programs prepared and collected elsewhere each one retain its particular licence, please comply with them.



#This script takes all the SARS-COV-2 fastq files within a folder and  #clean the reads, pileup them and generate several outputs. 

PATH+=:/home/laboratorionacional/anaconda3/bin


##Start of declaration for positionals arguments.
output_dir="$1"

##End of declaration for positionals arguments.


start=$(date +%s.%N)


################################################################
################SARS-CoV-2 Analysis#############################


	now1="$(date +%c)"
	echo "#####################SARS-CoV-2 pipeline started at $now1#######################"
	echo "################### Reviewing and unzipping files #########################"    
	for read_1 in $output_dir/*fastq  
    do
    if [[ -r $read_1 ]] ; 
    then
    echo "Using the following files for analysis"
    echo "using $read_1 reads" 
    else
    echo "Not fastq file provided looking for fastq.gz files"
    for fastqgz in $output_dir/*.fastq.gz 
    do
    if [[ -r $fastqgz ]] ; 
    then
    echo "fastq.gz files found unziping them"
    gunzip -f $output_dir/*.gz
    echo "unziping done!!!"    
    else
    echo "Neither gz or fastq files provided for analysis"
    echo "############################################"
    fi
    done
    fi
	done

	echo "                                                                           " 
	echo "                                                                           "     
	echo "############################################"
	echo "starting SARS-Cov-2019 Virus consensus generation"

	######## Manually into quasitools
	#cp SARS2.fas  /home/laboratorionacional/anaconda3/lib/python3.8/site-packages/quasitools/data/hxb2_pol.fas
	#cp SARS2.bed /home/laboratorionacional/anaconda3/lib/python3.8/site-packages/quasitools/data/hxb2_pol.bed
	#cp SARS2_mutation_db.tsv  /home/laboratorionacional/anaconda3/lib/python3.8/site-packages/quasitools/data/mutation_db.tsv
	#bowtie2-build /home/laboratorionacional/anaconda3/lib/python3.8/site-packages/quasitools/data/hxb2_pol.fas /home/laboratorionacional/anaconda3/lib/python3.8/site-packages/quasitools/data/hxb2_pol


	echo "############################################"

	echo "############################################"
	mkdir $output_dir/analysis/
	sudo chmod 777 $output_dir/analysis/
	mkdir $output_dir/analysis/coverage/
	mkdir $output_dir/analysis/aafiles/  
	mkdir $output_dir/analysis/vcffiles/  
	mkdir $output_dir/analysis/fastas/
	mkdir $output_dir/analysis/nextclade/
	mkdir $output_dir/analyzedfiles  
	sudo chmod 777 $output_dir/analyzedfiles
  
  ####################################################################################################
  #TESTING PURPOSE
  #read_1="/home/laboratorionacional/Documents/COVIDSeq/Test/verfastq/3684_S8_L001_R1_001.fastq"
  #output_dir="/home/laboratorionacional/Documents/COVIDSeq/Test/verfastq/"
  ##################################################################################################
  
	for read_1 in $output_dir/*R1*
	do 
	read_2=${read_1/R1/R2}
  
	c=$(echo $read_1 | awk -F "_S" '{print $1}')
	d=$(echo $c | awk -F "/" '{print $8}')
	echo "C es" $c
	echo "D es" $d
	echo "starting $d SARS-Cov-2019 Analysis"
	echo "############################################"
	now="$(date +%c)"
	echo -e "starting $d SARS-Cov-2019 Analysis at \t$now" >> "$output_dir/analysis/mensajes.log"

	echo "starting $d primers removal"
	echo "################################################"
	bwa mem -t 6 /home/laboratorionacional/Documents/COVLNS/GencomMod/data/SARS2.fas $read_1 $read_2 | python /home/laboratorionacional/Documents/COVLNS/GencomMod/Alt_nCov/trim_primer_parts.py /home/laboratorionacional/Documents/COVLNS/GencomMod/data/primerv3.bed $read_1 $read_2
	echo "starting $d quasitools quality control and mapping"
	echo "################################################"
	quasitools hydra -mf 0.15 -vq 70 -i $d  $read_1 $read_2 -o $output_dir/analysis/$d 
	/home/laboratorionacional/Documents/COVLNS/GencomMod/makeconsensus-illumina2.sh $output_dir $d     
	sed -i -r '1{s/frame: 0/gene_position,'$d'/g}' $output_dir/analysis/$d/coverage_file.csv 
	cp $output_dir/analysis/$d/coverage_file.csv $output_dir/analysis/coverage/coverage_file_$d.csv

	python /home/laboratorionacional/Documents/COVLNS/GencomMod/changevalueincsv.py $output_dir/analysis/$d $d

	python /home/laboratorionacional/Documents/COVLNS/GencomMod/changevalueinaavf.py $output_dir/analysis/$d $d

	/home/laboratorionacional/Documents/COVLNS/GencomMod/generatevariantfilesars2.sh $output_dir $d

	/home/laboratorionacional/Documents/COVLNS/GencomMod/runingpango.sh $output_dir/analysis/$d/$d.fas $output_dir/analysis/$d/ 4
	cp $output_dir/analysis/$d/*_mutation* $output_dir/analysis/aafiles/.
	cp $output_dir/analysis/$d/$d.fas $output_dir/analysis/fastas/.    
  	cp $output_dir/analysis/$d/*_final_* $output_dir/analysis/vcffiles/.
	samtools depth -aa $output_dir/analysis/$d/align.bam | awk -v sample=$d '{$1=sample ; print;}' >  $output_dir/analysis/$d/$d.tsv
	samtools coverage $output_dir/analysis/$d/align.bam >  $output_dir/analysis/$d/$d.coverage
	samtools stats $output_dir/analysis/$d/align.bam | grep ^SN | cut -f 2- | grep 'average length:' >  $output_dir/analysis/$d/$d.readlength
	awk -v sample=$d '{$1=sample ; print;}' $output_dir/analysis/$d/$d.tsv > $output_dir/analysis/coverage/coverage_file_$d.tsv

	Rscript  /home/laboratorionacional/Documents/COVLNS/GencomMod/Code_for_reference.R "SARS-CoV-2019 Genome coverage" $output_dir/analysis/$d/coverage_file.csv SARS-CoV-2019

	echo "finished $d SARS-Cov-2019 Analysis"
	echo "################################################"
	now="$(date +%c)"
	echo -e "finished $d SARS-Cov-2019 Analysis at \t$now" >> "$output_dir/analysis/mensajes.log"
	
	mv $read_1 $output_dir/analyzedfiles/.
	mv $read_2 $output_dir/analyzedfiles/.

	done
	
	echo "drawing final plots of the run"
	echo "################################################"
	cat $output_dir/analysis/coverage/coverage_file_*.tsv >  $output_dir/analysis/coverage/depth_file.tsv

	python /home/laboratorionacional/Documents/COVLNS/GencomMod/plotgroupedcoverage.py $output_dir/analysis
	cat $output_dir/analysis/fastas/*.fas > $output_dir/analysis/fastas/consensus.fasta
	/home/laboratorionacional/Documents/COVLNS/GencomMod/runingpango.sh $output_dir/analysis/fastas/consensus.fasta $output_dir/analysis/fastas/ 15


nextclade --in-order --input-fasta $output_dir/analysis/fastas/consensus.fasta --input-dataset /home/laboratorionacional/Documents/COVLNS/GencomMod/data/sars-cov-2 --output-tsv $output_dir/analysis/nextclade/nextclade.tsv --output-tree $output_dir/analysis/nextclade/nextclade.auspice.json --output-dir $output_dir/analysis/nextclade/ --output-basename nextclade



echo "################################################"
	echo "moving fastq files and zipping them"
echo "################################################"  

	pigz $output_dir/analyzedfiles/*fastq
end=$(date +%s.%N)    
runtime=$(python -c "print((${end} - ${start})/60)")

now="$(date +%c)"


echo "################################################"
echo "gencom_beta.v2 Analysis has finished"
echo "################################################"
echo "Finalizado a las $end"
echo "Tiempo total de corrida  $runtime minutos"
echo "################################################"
echo -e "finalizing $test at \t$now \tTotal runtime: \t $runtime minutos" >> "$output_dir/analysis/mensajes.log"
	exit 1



