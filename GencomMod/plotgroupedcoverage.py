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


import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import fileinput
import sys
import glob

file1=sys.argv[1]
#name=sys.argv[2]
inputcsv=file1+"/coverage/depth_file.tsv"
outputcsv=file1+"/"+"coverage/individualdepth_plot.png"
#print(inputcsv)

text = open(inputcsv, "r")

sns.set_theme(style="ticks")

df = pd.read_csv(inputcsv, sep=' ', low_memory=False)

df.columns =['Sample', 'pos', 'depth']
print("leido")
#print(df)
# Initialize a grid of plots with an Axes for each walk
times = df.pos.unique()
grid = sns.FacetGrid(df, col="Sample", hue="Sample", palette="tab20c",
                    col_wrap=4, height=2)

print("grid made")
#print(grid)
# Draw a horizontal line to show the starting point
grid.refline(y=10, linestyle=":")

grid.refline(y=100, linestyle=":")


# Draw a line plot to show the trajectory of each random walk
grid.map(plt.plot, "pos", "depth")

grid.refline(y=1000, linestyle=":")

print("reflines done")

# Adjust the tick positions and labels
grid.set(xticks=np.arange(0, 30000, step=10000), yticks=[0, 10, 100, 10000],
         xlim=(1, 30000), ylim=(3.5,50000), yscale="log")

print("grid set")

# Adjust the arrangement of the plots
grid.fig.tight_layout(w_pad=1)
grid.savefig(outputcsv)