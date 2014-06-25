#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Mon Mar 24 15:34:25 2014
###################################
use strict;
use warnings;

foreach my $i (6,9,12,13,15,16){
#foreach my $i (9,12){
    my $com="macs14 -t ../../align/TAC-${i}_norm_sorted_rmdup_nochrM.bam -g mm -n TAC-${i}";
    print $com,"\n\n";
    `$com`;
}
