#!/usr/bin/Rscript
##############################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Tue Mar 18 13:15:03 2014
##############################################
args<-commandArgs(trailingOnly=TRUE)
infile<-args[1]
sample.names<-args[2]
outfile=paste(sample.names,"_insertSize.pdf",sep="")

a<-scan(infile)
pdf(outfile)
plot(density(a,from=0,to=quantile(x=a,probs=0.99)),xlab="Insert Size (bp)",main=sample.names)
dev.off()

