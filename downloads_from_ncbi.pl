#!/usr/bin/perl -w
use strict;

my %link;

my $file_to_open= shift; # assembly_summary.txt
# Acidianus_hospitalis	W1	Representative	2011	ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/213/215/GCF_000213215.1_ASM21321v1

open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
    if( /^.*genome\s+\d+\s+\d+\s+([^\t]+).*\s+(ftp:\/\/.*\/([^\/\s]+))[\s+\n]/ ){
        $link{$1}= $2;
        next
    }
}

foreach my $key ( sort keys %link ){
    print STDERR "$key\n$link{$key}\n";
    (my $dir= $key)=~ s/ /_/g;
    mkdir $dir;
    chdir $dir;
    my $command= "wget -r -l1 -np -nH --cut-dirs 20 \"$link{$key}/\" -A \"*_cds_from_genomic.fna.gz,*_feature_table.txt.gz,*_genomic.fna.gz\"";
    print STDERR "$command\n";
    system("$command");
    chdir '..';
    #~ exit
}

