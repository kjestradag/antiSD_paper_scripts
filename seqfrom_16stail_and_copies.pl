#!/usr/bin/perl -w
use strict;

# Receive a list with the paths of dir/archivofasta_16s and output for each fasta the last 15 bases of the 16s and the number of copies

my $file_to_open= shift;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	my $count;
	chomp;
	if( /^\.\/([^\/]+)\/(\S+)/ ){
    	print "$1\t";
    	my $file_to_open= $_;
        open FASTA, $file_to_open or die "Cant read $file_to_open\n";
        while(<FASTA>){
        	if (/^>/){
				$count++;
				next;
			};
			chomp;
			print "\t",substr($_, -15);
        }
	print "\t$count\n";
    }
}


__END__
./GCA_900156015.1/GCA_900156015.1.rib_complete_tail.fna
