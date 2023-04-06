#!/usr/bin/perl -w
use strict;

use Parallel::ForkManager;
my $pm = new Parallel::ForkManager(48);

#~ Extract the 16S end from all copies per organism. Align them with MAFFT and return whether they are identical or not

my $file_to_open= shift; # 16slist
open IN, $file_to_open or die "Cant read $file_to_open\n";
while (<IN>){
    chomp;
    $pm->start and next;
		chomp;
		my $fasta= $_;
		(my $org= $fasta)=~ s/\.\/([^\/]+).*/$1/;
	    open IN2, $fasta or die "Cant read $fasta\n";
	    open OUT, ">tmp$org";
	    while(<IN2>){
			if( /^>/ ){
	        	print OUT;
	        	next
	        }else{
				chomp;
				print OUT "",substr($_, -20,20), "\n";
			}
	    }
	    system("mafft --thread 1 --clustalout tmp$org > mafft$org 2>/dev/null");
	    my $iden= cntidentities("mafft$org");
	    print "$org\t$iden\n";
	    $iden && unlink("mafft$org", "tmp$org");
	    close OUT;
    $pm->finish;
}
$pm->wait_all_children;


sub cntidentities{
	my $mafft= shift;
    open IN3, $mafft or die "Cant read $mafft\n";
    while(<IN3>){
    	if( /^\s+\*{20}/ ){
        	return 1;
        	last;
        }
    }
    return 0;
}

__END__
16slist:
./zpl/zpl.rib_complete_tail.fna
./zpr/zpr.rib_complete_tail.fna

mafft:
mafft --thread 1 --clustalout /var/tmp/cosa_040423135453

mafft output:
CLUSTAL format alignment by MAFFT FFT-NS-2 (v7.453)


CP001650_2      gtagccgtaccggaaggtgcggctggaacacctcctttct
CP001650_3      gtagccgtaccggaaggtgcggctggaacacctcctttct
CP001650_4      gtagccgtaccggaaggtgcggctggaacacctcctttct
                ****************************************
