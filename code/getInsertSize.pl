#!/usr/bin/env perl
###################################
# Author: Jiang (River) Li
# Email:  riverlee2008@gmail.com
# Date:   Tue Mar 18 12:21:53 2014
###################################
use strict;
use warnings;

my $usage ="perl getInsertSize.pl in.bam \n";
die $usage if (@ARGV !=1);

my $inbam = shift @ARGV;

open(OUT,">insertSize.tmp") or die $!;

open(IN,"samtools view $inbam |") or die $!;
while(<IN>){
    my @a = split "\t";
    next if ($a[2] eq "chrM");
    my $in=$a[8];
    if($in=~/^\d/){
        print OUT $in."\n";
     }
}
close IN;
close OUT;
