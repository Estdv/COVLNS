#bin/bash

#test="$1"
#read_1="$2"
#read_2="$3"
output_dir="$1"
sample="$2"
#echo $test
#source activate conses

	for read_1 in $output_dir/analysis/$sample/$sample.fas
	do #echo $read_1
    echo $read_1
	c=$(echo $read_1 | awk -F "_S" '{print $1}')
	d=$(echo $c | awk -F "/" '{print $2}')
    echo $output_dir
    echo $d
    python /home/laboratorionacional/Documents/COVLNS/GencomMod/MicroGMT/sequence_to_vcf.py -r /home/laboratorionacional/Documents/COVLNS/GencomMod/MicroGMT/NC_045512_source_files/NC_045512.fa -i assembly -fs $read_1 -o $output_dir/analysis/$sample/
    python /home/laboratorionacional/Documents/COVLNS/GencomMod/MicroGMT/annotate_vcf.py -i $output_dir/analysis/$sample/ -c -o $output_dir/analysis/$sample/ -rg /home/laboratorionacional/Documents/COVLNS/GencomMod/MicroGMT/test_datasets/SARS-CoV-2_test_datasets/region.tsv  -eff /home/laboratorionacional/Documents/COVLNS/GencomMod/MicroGMT
    python /home/laboratorionacional/Documents/COVLNS/GencomMod/changevalueianno.py $output_dir/analysis/$sample/$sample.anno.vcf $sample

	done
    
#conda deactivate