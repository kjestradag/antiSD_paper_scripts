#!/usr/bin/perl -w
use strict;
use Math::Round;

# Extract the data from the bases that passed the 40 percent cutoff

my (%data);
my $mayor= 0;

my $file_to_open= shift; # ~db/Doc/posgrado/doc/9no_semestre/Analisis_de_RNAhybrid_por_clase_filogenetica_8dic/*.txt
(my $name= $file_to_open)=~ s/\.txt//;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	chomp;
	$data{(split)[1]}= (split)[2];
	$mayor < (split)[2] && ($mayor = (split)[2]);
}

my $thold= $mayor*40/100;
my @pos;

if( $mayor >= 10 ){
	print "$name\t",sprintf("%.2f", $mayor),"\t",sprintf("%.2f", $thold),"\t";
	foreach my $pos ( sort {$a<=>$b} keys %data ){
		print "$pos," if round($data{$pos}) >= $thold;
		push @pos,$pos if round($data{$pos}) >= $thold;
	}
	print "\t",sprintf("%.1f", mean(\@pos)),"\n";
}

sub mean{
    my($data) = @_;
    if (not @$data) {
            die("Empty array\n");
    }
    my $total = 0;
    foreach (@$data) {
            $total += $_;
    }
    my $average = $total / @$data;
    return $average;
}



__END__

Bacteria_Proteobacteria_Gammaproteobacteria  1    1.121096   0.106028   0.126337  0.727341   0.16139    0.154674   0.67924    0.133054  0.154128
Bacteria_Proteobacteria_Gammaproteobacteria  2    4.351128   0.517623   0         2.737367   1.096137   1.096137   2.487613   0         0.767377
Bacteria_Proteobacteria_Gammaproteobacteria  3    11.042706  0.806306   0         0.362422   9.873978   9.872474   0          0.001504  1.168729
Bacteria_Proteobacteria_Gammaproteobacteria  4    25.589095  18.570815  0         6.980684   0.037597   0.037597   0          0         25.551499
Bacteria_Proteobacteria_Gammaproteobacteria  5    38.906247  32.17475   0         6.731497   0          0          0.099187   0         38.807061
Bacteria_Proteobacteria_Gammaproteobacteria  6    50.314474  0          0         50.311714  0.002761   0.002761   50.311714  0         0
Bacteria_Proteobacteria_Gammaproteobacteria  7    55.672444  0.105398   0         55.563734  0.003313   0.003313   55.552806  0         0.116325
Bacteria_Proteobacteria_Gammaproteobacteria  8    57.713755  52.49936   0         5.214395   0          0          0.08393    0         57.629825
Bacteria_Proteobacteria_Gammaproteobacteria  9    42.775244  0          0         42.771379  0.003865   0.003865   42.771379  0         0
Bacteria_Proteobacteria_Gammaproteobacteria  10   25.155234  0          0         25.113781  0.041453   0.041453   25.113781  0         0
Bacteria_Proteobacteria_Gammaproteobacteria  11   16.603349  0.002761   0         0.02909    16.571498  16.571498  0.028538   0         0.003313
Bacteria_Proteobacteria_Gammaproteobacteria  12   12.342819  0.064117   0         12.277046  0.001656   0.001656   12.261206  0         0.079956
Bacteria_Proteobacteria_Gammaproteobacteria  13   10.036379  8.066751   0.011858  1.948335   0.009434   0.006011   0          0.015282  10.015087
Bacteria_Proteobacteria_Gammaproteobacteria  14   5.051426   0          0.002254  0          5.049172   5.047001   0          0.004425  0
Bacteria_Proteobacteria_Gammaproteobacteria  15   3.647524   0          2.953089  0          0.694435   0          0          3.647524  0



redefinir el core: CCUCCUU

aplicar este script a txts de los orgs individuales para ver casos extremos como las acidolobus

claramente hay patrones de aSD conservados en muchas clases
