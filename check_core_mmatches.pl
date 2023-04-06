#!/usr/bin/perl -w
use strict;

#~ Check in the non-identical 16S copies if this difference is in the core CCUCC

my $file_to_open= shift; # "mafftlist"
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	chomp;
	(my $org= $_)=~s/mafft//;
	my ($lines, $core)= (0,0);
    open IN2, $_ or die "Cant read $_\n";
    while(<IN2>){
    	chomp;
    	next if /^CLUSTAL/;
    	if( /^\S+\s+.*cctcc/ || /^\S+\s+.*CCTCC/ ){
        	$lines++;
        	$core++;
        }elsif(/^\S+/){
        	$lines++;
        }
    }
    print "$org\t$lines\t$core\n" if ($lines != $core);

}

__END__
CLUSTAL format alignment by MAFFT FFT-NS-2 (v7.453)


CP009787_2      cctcctta-
CP009787_3      cctcctta-
CP009787_4      cctcctta-
CP009787_5      -ctccttac
CP009787_6      cctcctta-
CP009787_7      cctcctta-
CP009787_8      cctcctta-
                 *******
