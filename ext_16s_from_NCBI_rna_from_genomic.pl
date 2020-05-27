#!/usr/bin/perl -w
use lib "$ENV{'HOME'}/perl"; 
use yo qw(:DEFAULT); 
use Data::Dumper;     # Hint: print Dumper(\@cosa); 
use strict;

my ($dir, $fasta, $name, %seq);

my $file_to_open= shift; #  rna_from_genomic_fna.paths == ( find . -name '*_rna_from_genomic.fna' > rna_from_genomic_fna.paths )
open IN, $file_to_open or die "Cant read $file_to_open\n"; 
while(<IN>){
    my ($name, %seq);
    chomp;
	if( /^\.\/([^\/]+)\/(\S+)/ ){
        ($dir, $fasta)= ($1, $2);
    }
    print STDERR "$dir, $fasta\n";
    chdir $dir;
    open IN2, $fasta or die "Cant read $fasta\n"; 
    my $good= 0;
    while(<IN2>){
        chomp;
        if( /^>(.*product=16S ribosomal.*$)/ ){
            $name= $1; 
            $good++; next
        }elsif( /^>/ ){
            $good= 0; next
        }
        $seq{$name}.= $_ if $good;
    }
    open OUT, ">${dir}_16S.fna";
    foreach my $ribo ( sort keys %seq ){
        print OUT ">$ribo\n$seq{$ribo}\n";
    }
    
    chdir '..';

#     exit;
}
