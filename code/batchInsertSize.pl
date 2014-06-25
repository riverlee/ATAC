#!/usr/bin/env perl
###################################
# Author: Jiang (River) Li
# Email:  riverlee2008@gmail.com
# Date:   Tue Mar 18 14:22:08 2014
###################################
use strict;
use warnings;

my $dir="../insertSize";
mkdir $dir if (! -e $dir);
chdir($dir) or die $!;


my @bams = <../align/*norm_sorted_rmdup_nochrM.bam>;
foreach my $bam (@bams){
    my $name=$bam;
    $name=~s/.*\/|_norm_sorted_rmdup_nochrM\.bam//g;
    print $name,"\n";

    `perl ../code/getInsertSize.pl $bam`;
    `mv insertSize.tmp ${name}_insertSize.data.txt`;
    `../code/plotInsertSize.R ${name}_insertSize.data.txt $name`;
}

