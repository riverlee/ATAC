#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Wed Apr  9 10:48:12 2014
###################################
use strict;
use warnings;
###################################
# Instead of extracting the mapping intervals of each read/mate, 
# the script will extract the biological fragment position and 
# output it in bed format.
###################################

# check parameters
if (@ARGV !=2){
    usage();
    exit(1);
}

# Read parameters
my ($in,$out) = @ARGV;

if(! -e $in){
    print "Input bam '$in' is not exists\n";
    usage();
    exit(1);
}

###### Main ############
my $rand=rand();
my $tmpfile = "$rand.bed";

# print $rand,"\n";

# 1) Will first invoke bamToBed
`bamToBed -i $in >$tmpfile`;

# 2) Read the tmp file to get the fragment positions

open(IN,"$tmpfile") or die $!;
my %hash;

while(<IN>){
    chomp;
    # no chrm Reads
    my($chr,$start,$end,$name,$score,$strand) = split "\t";
    next if ($chr eq "chrM" || $chr eq "MT");
    if($name=~/(.*)\/([12])/){
        push @{$hash{$1}->{$chr}->{interval}},$start,$end;
        if($2==1){
            $hash{$1}->{$chr}->{strand}=$strand;
        }
    }
}
close IN;

# 3) Write out
open(OUT,">$out") or die $!;
foreach my $fragment (keys %hash){
    foreach my $chr (keys %{$hash{$fragment}}){
        my @aa = @{$hash{$fragment}->{$chr}->{interval}};
        @aa = sort {$a <=>$b } @aa;
        print OUT join "\t",($chr,$aa[0],$aa[$#aa],$fragment,$aa[$#aa]-$aa[0],$hash{$fragment}->{$chr}->{strand}."\n");
    }
}
close OUT;

END{
    if(defined ($tmpfile) && -e $tmpfile){
        unlink $tmpfile;
    }
}
sub usage{
    print <<EOF;
Usage: getFragmentBed.pl in.bam out.bed
-----------------------------------------------------------
Instead of extracting the mapping intervals of each read/mate, 
the script will extract the biological fragment position and 
output it in bed format.
-----------------------------------------------------------
in.bam   -- input file in bam format
out.bed  -- output file 

EOF

}
