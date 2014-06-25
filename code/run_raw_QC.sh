#!/bin/bash
###################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Thu Oct  3 15:16:55 2013
###################################
# Take the raw data (fastq) and run FastQC on it

#1)  get to the parental folder
cd ../

#2) make directory if not exists
qcdir="QC_raw"
if [ ! -d $qcdir ]; then
    mkdir $qcdir
fi
 
#3) loop the files in the rawdata folder and run the fastqc
rawdatadir="rawdata"
command="fastqc -t 30 -o $qcdir --nogroup "
#for f in `ls $rawdatadir/*/*.fastq.gz`;do
for f in `ls $rawdatadir/*.fastq`;do
    echo $f
    command="$command $f" 
done

#4) print the command and run it
echo $command 
time $command

#5) Merget the report together
merge_fastqc_report.pl -d QC_raw
