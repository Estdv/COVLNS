#!/usr/bin/env python

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



import fileinput
import sys
import glob
import csv

file1=sys.argv[1]
name=sys.argv[2]
inputcsv=file1+"/dr_report.csv"
outputcsv=file1+"/"+name+"_aa_report.csv"
#print(inputcsv)

text = open(inputcsv, "r")
text = ''.join([i for i in text]) \
    .replace("AF033819", name) .replace("Chromosome", "Sample")
x = open(outputcsv,"w")
x.writelines(text)
x.close()