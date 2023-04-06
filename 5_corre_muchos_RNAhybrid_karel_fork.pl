#!/usr/bin/perl -w

use lib qw(. /home/karel/perl5/lib/perl5/);
use Parallel::ForkManager;

#~ Running RNAhybrid for all organisms (the free end of their 16S vs. the 5' UTR regions of their messengers)

#use Parallel::ForkManager;
my $pm = new Parallel::ForkManager(64);


my $file_to_open= "colitas_30_16S_new5";
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	chomp;
    $pm->start and next;
		run($_);
    $pm->finish;
}
$pm->wait_all_children;

sub run{
	my $line= shift;
	($org,$sec) = split(/\t/,$line);
	$n++;
	print "$n\t$org\n";
	$infile = "Upstream_14-4_ATG_new/".$org;
	$outfile = "Output_RNAhybrid_new/".$org;

	$r = "RNAhybrid -t $infile $sec -d xi > $outfile";
	system("$r");
}
