#!/usr/bin/python

import time
import os
import sys
import subprocess
import argparse
from functions import *

def main():
	parser = argparse.ArgumentParser(description='Analysis utilities', \
		formatter_class=argparse.RawTextHelpFormatter)
	group1 = parser.add_argument_group('Mandatory inputs')
	group1.add_argument('-i', type=str, dest='in_table', \
		required=True, \
		help='Input summary table (format 2 table)')
	group1.add_argument('-o', type=str, dest='out_table', \
		required=True, \
		help='Processed output table')
	group1.add_argument('-t', dest='type_of_analysis', \
		required=True, choices=['a','b'], \
		help='Type of analysis (a: format change, b: find unique mutations)')
	group1.add_argument('-a', dest='include_annot', \
		required=True, choices=['y','n'], \
		help='The summary table include custom annotation or not? (y: yes, n: no)')

	group2 = parser.add_argument_group('Optional arguments')
	group2.add_argument('-l', type=str, dest='log', default="Analysis_utilities.log", \
		help='Directory and name of the log file [Analysis_utilities.log]')

	args = parser.parse_args()

	param = {}
	param['in_table'] = os.path.join(os.getcwd(),args.in_table)
	param['out_table'] = os.path.join(os.getcwd(),args.out_table)
	param['type'] = args.type_of_analysis
	param['out_log'] = args.log
	param['include_annot'] = args.include_annot

	with open(param['out_log'],'w') as f:
		f.write('[MicroGMT ' + \
			time.asctime( time.localtime(time.time()) ) + \
			'] Analysis utilities script started.\n')

	f.close()

	log_print(param['out_log'],'==================== MicroGMT ====================')
	log_print(param['out_log'],'               Analysis_utilities')
	log_print(param['out_log'],'             Version 1.3  (June 2020)')
	log_print(param['out_log'],'   Bug report: Yue Xing <yue.july.xing@gmail.com>')
	log_print(param['out_log'],'======================================================')

	if param['type']=="a":
		log_print(param['out_log'],"Changing table format for format2 tables started...")
		if param['include_annot']=="n":
			change_table_format(param['in_table'],param['out_table'])
		else:
			change_table_format_wanno(param['in_table'],param['out_table'])
	elif param['type']=="b":
		log_print(param['out_log'],"Finding uniqe mutations started...")
		if param['include_annot']=="n":
			find_uniq_mutations(param['in_table'],param['out_table'])
		else:
			find_uniq_mutations_wanno(param['in_table'],param['out_table'])

	log_print(param['out_log'],"Successfully completed!")

if __name__ == '__main__':
	main()
