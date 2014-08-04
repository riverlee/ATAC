#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Wed Apr  9 14:58:03 2014
###################################
use strict;
use warnings;

my $usage=<<USAGE;
Usage: preShift.pl in.bed size out.bed
in.bed  -- Your input alignment in bed format
size    -- shiftsize
out.bed -- Your output file
Example: preShift in.bed 75 out_preShift75.bed
USAGE

if(@ARGV !=3){
    print $usage;
    exit 1;
}

my ($in,$size,$out) = @ARGV;

if(! -e "$in") {
    print "input file '$in' doesn't exists\n";
    print $usage;
    exit 1;
}

if($size!~/^\d+$/){
    print "size '$size' is not an integer\n";
    print $usage;
    exit 1;
}

open(IN,"$in") or die $!;
open(OUT,">$out") or die $!;
while(<IN>){
    chomp;
    my($chr,$start,$end,$name,$score,$strand) = split "\t";
    if($strand eq "+"){
        $start = $start - $size;
        $end = $end - $size;
    }else{
        $start = $start + $size;
        $end = $end + $size;
    }
    $start = 0 if ($start <0);
    print OUT join "\t",($chr,$start,$end,$name,$score,$strand."\n");
}
close IN;
close OUT;

