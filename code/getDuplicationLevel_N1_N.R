#!/usr/bin/Rscript
##############################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Wed Apr  9 13:43:42 2014
##############################################
args<-commandArgs(trailingOnly=TRUE)
if(length(args)!=1){
    cat("Usage: getDuplicationLevel_N1_N.R in.counts.txt\n"); 
    cat("----------------------------------------------\n");
    cat("Calculate the duplication level based on N1/N. N1 is");
    cat("\nthe number of mapped unique fragments, N is the total\n");
    cat("number of mapped fragments\n");
    cat("----------------------------------------------\n");
    cat("in.counts.txt  -- input file which is the output of getDuplicationLevel.pl\n");
    q()
}

d<-read.delim(args[1])

v<-d[1,2]/sum(d[,2])
cat("N1/Nd=",v,"\n")
cat("N1/N2=",d[1,2]/d[2,2],"\n");
