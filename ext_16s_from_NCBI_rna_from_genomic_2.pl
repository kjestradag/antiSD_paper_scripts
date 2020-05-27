#!/usr/bin/perl -w
use lib "$ENV{'HOME'}/perl"; 
use yo qw(:DEFAULT); 
use Data::Dumper;     # Hint: print Dumper(\@cosa); 
use strict;

my ($dir, $fasta, $name, %seq);

my $file_to_open= shift; #  16S_from_genomic_fna.paths == ( find . -name '*_16S.fna' > 16S_from_genomic_fna.paths )
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
        if( /^>(.*product=16S ribosomal.*\[location=complement\(<\d+\.\..*$)/ ){
            $name= $1; 
            $good= 0; next
        }elsif( /^>(.*product=16S ribosomal.*\[location=complement\(\d+\.\..*$)/ ){
            $name= $1; 
            $good++; next
        }elsif( /^>(.*product=16S ribosomal.*\[location=.*\.\.\d+.*$)/ ){
            $name= $1; 
            $good++; next
        }elsif( /^>/ ){
            $good= 0; next
        }
        $seq{$name}.= $_ if $good;
    }
    open OUT, ">${dir}_best16S.fna";
    foreach my $ribo ( sort {length($seq{$b}) <=> length($seq{$a})} keys %seq ){
        print OUT ">$ribo\n$seq{$ribo}\n";
        last;
    }
    
    chdir '..';

#     exit;
}
