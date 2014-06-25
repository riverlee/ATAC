#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Wed Apr  9 13:17:06 2014
###################################
use strict;
use warnings;

if(@ARGV !=2){
    usage();
    exit 1;
}
my ($in,$out) = @ARGV;
if(! -e $in){
    print "Input file '$in' is not exists\n";
   usage();
   exit 1;
}

system ("cut -f1-3 $in |sort -k1,1 -k2,2n -k3,3n|uniq -c |awk '{print \$1}'|sort |uniq -c |awk 'BEGIN{OFS=\"\\t\";print \"Duplication Level\",\"Counts\"}{print \$2,\$1}' |sort -k1,1n > $out");

sub usage{
    print <<EOF;
Usage: getDuplicationLevel.pl in.bed out.txt
------------------------------------------------
Take the output of 'getFragmentBed.pl' and get the
duplication level of mapped reads.
------------------------------------------------
in.bed    -- input file
out.txt   -- output file

EOF
}
