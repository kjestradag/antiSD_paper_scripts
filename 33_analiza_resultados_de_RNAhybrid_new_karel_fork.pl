#!/usr/bin/perl -w
use lib qw(. /home/karel/perl5/lib/perl5/);

#~ Analyzing the output of RNAhybrid and turning it into a frequency table by position

use Parallel::ForkManager;
my $pm = new Parallel::ForkManager(94);

$cutoff_delta = -8.4;

%rel;
$file_to_open= "colitas_30_16S_new5";
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	chomp;
	$rel{(split)[0]}= length((split)[1]);
}


my $file_to_open= "colitas_30_16S_new5_fixed.list";
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	chomp;
    $pm->start and next;
		run($_);
    $pm->finish;
}
$pm->wait_all_children;

sub run{
	$org= shift;
		$i = 0;
		undef @linea;
		$n_genes = `wc -l /home/fastas_2206/$org.faa | cut -f1 -d " "`;

	if ($n_genes > 100) {
		$n_genes = $n_genes/2;
		print "$org $n_genes\n";
		$factor = 100000000/$n_genes;
		$infile = "Output_RNAhybrid_new/".$org;
		$outfile = "Analisis_de_RNAhybrid_8dic/".$org.".txt";
		open(S,">$outfile");
		undef @suma_mRNA;	undef @suma_16S;
		undef @suma_mRNA; undef @suma_16S;
		foreach $linea (split(/\n/,`cat $infile`))
	        	{
			$i++;
			$linea[$i] = $linea;
			}

		$n = 0;
		while ($n <= $i)
			{
			$n++;
			if ($linea[$n] =~ "mfe:")
				{
				($delta) = (split(/ +/,$linea[$n]))[1];
				if ($delta < $cutoff_delta)
					{
					$target = 0;
					while ($target < 1)
						{
						$n++;
						if ($linea[$n] =~ "target 5") { $target = 1 }
						}
					undef @ok_mRNA; undef@ok_16S;
					@l1 = split(//,$linea[$n]);
					$n++;
					@l2 = split(//,$linea[$n]);
					$n++;
					@l3 = split(//,$linea[$n]);
					$n++;
					@l4 = split(//,$linea[$n]);

					$p_mRNA = 0; $p_16S = 0;
                                        foreach $k (10..(9+$rel{$org}))
						{
						if (@l3[$k] ne " " || @l4[$k] ne " " )
							{
							$p_16S++;
							}
						if (@l3[$k] ne " ")
							{
							$suma_mRNA[$p_16S] = $suma_mRNA[$p_16S].@l2[$k];
							$suma_16S[$p_16S] = $suma_16S[$p_16S].$l3[$k];
							}
						}
				 	}
				}
			}
                 foreach $i (1..$rel{$org})
			{
			$bases = $suma_mRNA[$i];
			$lon_inicial = int((length($bases) + 0) * $factor + 0.5)/1000000;
			print S "$org\t$i\t$lon_inicial\t";
			&cuenta_bases;
			$bases = $suma_16S[$i];
			$lon_inicial = length($bases);
			&cuenta_bases;
			print S "\n";
			}
		}
	close(S);
}

sub cuenta_bases {
$lon_1 = length($bases);;
$bases =~ tr/A//d;
$lon_2 = length($bases);
$As = int(( $lon_1 - $lon_2 + 0) * $factor + 0.5)/1000000;

$lon_1 = $lon_2;
$bases =~ tr/C//d;
$lon_2 = length($bases);
$Cs = int(( $lon_1 - $lon_2 + 0) * $factor + 0.5)/1000000;

$lon_1 = $lon_2;
$bases =~ tr/G//d;
$lon_2 = length($bases);
$Gs = int(( $lon_1 - $lon_2 + 0) * $factor + 0.5)/1000000;

$Ts = int(( $lon_2 + 0) * $factor + 0.5)/ 1000000;

print S "$As\t$Cs\t$Gs\t$Ts\t";
}
