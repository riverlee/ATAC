#!/usr/bin/env perl
###################################
# Author: Jiang (River) Li
# Email:  riverlee2008@gmail.com
# Date:   Thu Apr  3 16:51:20 PDT 2014
###################################
use strict;
use warnings;

# ATAC-Seq mapping analysis pipeline
# Will do initial mapping by bowtie and then remove duplicate and making UCSC tracking files
# All the result will be stored in the ../align folder

my $bowtie="bowtie";
my $index="/seq/reference/Mus_musculus/UCSC/mm9/Sequence/BowtieIndex/genome";
my $samtools="samtools";
my $bedGraphToBigWig="bedGraphToBigWig";
my $genomeCoverageBed="genomeCoverageBed";
my $chromosomesize="/seq/reference/Mus_musculus/UCSC/mm9/Annotation/Genes/ChromInfo.txt";

my $dir="../align";
mkdir "$dir" if (! -e "$dir");

my $trackdir="../tracks";
mkdir $trackdir if (! -e "$trackdir");

my @fastq=<../rawdata/*.fastq>;

# For pair-end
my %files;
foreach my $f (@fastq){
    my $n=$f;
    print $f,"\n";
    
    # To parse file names in order to get sample and mate information
    # The regular expression maybe a little different from projects to projects
    if($f=~/(TAC.*)_R(\d)/){
        $files{$1}->{$2}=$f;
     }
}

# Loop each samples and write the code to output
my $time=scalar(localtime);
foreach my $n (keys %files){
    my $out="${n}_ATAC-seq_mapping.sh";
    open(OUT,">$out") or die $!;

    print OUT <<BASH;
#!/bin/bash
###############################
# Author: Jiang (River) Li
# Email:  riverlee2008\@gmail.com
# Date:   $time
###################################

cd $dir
 
###############################
# Alignment
###############################
# 1 Alignment 
echo 'bowtie alignment' `date`
$bowtie --chunkmbs 2000 -p 24 -S -m 1 -X 2000  -t $index -1 $files{$n}->{1} -2 $files{$n}->{2}  ${n}.sam

# 2 Sam to bam and only output those mapped
echo "sam to bam (only output mapped)" `date`
$samtools view -bS ${n}.sam >${n}.bam
rm -rf ${n}.sam
$samtools view -b  -F 4 ${n}.bam >${n}_norm.bam

# 3 sort bam
echo "sort bam" `date`
$samtools sort ${n}_norm.bam ${n}_norm_sorted

# 4 Delete not sorted bam
echo "delete bam" `date`
rm -rf ${n}_norm.bam

# 5 remove duplicates
echo "remove duplicates" `date`
$samtools rmdup  ${n}_norm_sorted.bam ${n}_norm_sorted_rmdup.bam

# 6 remove chrM reads
echo "remove chrM reads" `date`
`$samtools view -h ${n}_norm_sorted_rmdup.bam |perl -lane 'print \$_ if \$F[2] ne "chrM"' |samtools view -bS - > ${n}_norm_sorted_rmdup_nochrM.bam`;
`$samtools index ${n}_norm_sorted_rmdup_nochrM.bam`;

# 7  make bedGraph
echo "make bedgraph" `date`
$genomeCoverageBed -bg -ibam ${n}_norm_sorted_rmdup_nochrM.bam -split -g $chromosomesize >${n}_norm_sorted_rmdup_nochrM.bedGraph

# 8 make bigwig
echo "make bigwig" `date`
$bedGraphToBigWig ${n}_norm_sorted_rmdup_nochrM.bedGraph $chromosomesize ${n}_norm_sorted_rmdup_nochrM.bw

`mv ${n}_norm_sorted_rmdup_nochrM.bedGraph $trackdir`;
`mv ${n}_norm_sorted_rmdup_nochrM.bw $trackdir`;


BASH
}
