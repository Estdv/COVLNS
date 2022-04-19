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

#This software uses diferent smart programs prepared and collected elsewhere each one retain its particular licence, please comply with them.



#This script takes all the fastq files within a folder and according to the pathogen chose #clean the reads, pileup them and generate several outputs. Currently the pathogen with more #application and outputs availables is SARS-CoV-2

input_dir="$1"
sample="$2"
REF_FILE=/home/laboratorionacional/Documents/COVLNS/GencomMod/data/SARS2.fas
#BAM_FILE=$3
#OUTPUT_FILE=$3
#SEQ_NAME=$4


###adapted script from https://doi.org/10.1038/s41591-021-01255-3####
	for BAM_FILE in $input_dir/analysis/$sample/align.bam
	do
    #echo $BAM_FILE
    REF_NAME=`cat $REF_FILE | grep '>' | tr -d '>' | cut -d ' ' -f 1`
    LENGTH=`tail -n +2 $REF_FILE | tr -d '\n' | wc -m | xargs`
    c=$(echo $BAM_FILE | awk -F "/align.bam" '{print $1}')
    #echo $c
    d=$(echo $c | awk -F "/" '{print $9}')
    #echo $d
    echo "############################################"
    echo "Starting $d consensus generation with bcftools mpileup"
    echo "############################################"
    echo -e "$REF_NAME\t$LENGTH" > $c/my.genome
    bedtools bamtobed -i $BAM_FILE > $c/reads.bed
    bedtools genomecov -bga -i $c/reads.bed -g $c/my.genome | awk  '$3 < 2' > $c/zero.bed
    maskFastaFromBed -fi $REF_FILE -bed $c/zero.bed -fo $c/masked.fasta
    bcftools mpileup -Ou -C50 -f $c/masked.fasta $BAM_FILE | bcftools call --ploidy 1 -mv -Oz -o $c/test.vcf.gz
    bcftools index $c/test.vcf.gz
    cat $c/masked.fasta | bcftools consensus $c/test.vcf.gz > $c/new_consensus.fasta
    
    #echo ">Panama/GMI-PA$d/2021" > $c/$d.fas
    echo ">$d" > $c/$d.fas
    tail -n +2 $c/new_consensus.fasta >> $c/$d.fas
    #rm $c/new_consensus.fasta $c/masked.fasta $c/masked.fasta.fai $c/zero.bed $c/reads.bed $c/my.genome $c/test.vcf.gz $c/test.vcf.gz.csi
    echo "############################################"
    echo "finishing $d consensus generation with bcftools mpileup"
    echo "############################################"
	done
    
#conda deactivate