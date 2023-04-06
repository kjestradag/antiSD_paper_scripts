#!/usr/bin/perl -w

#~ Analyzing the output of RNAhybrid and turning it into a frequency table by position

%rel;
$file_to_open= "colitas_30_16S_new5";
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
        chomp;
        $rel{(split)[0]}= length((split)[1]);
}

foreach $linea (split(/\n/,`cat orgs_S21_verificadas`))
	{
	($org,$filo) = split(/\t/,$linea);
	($kingdom,$phylum,$class) = (split(/,/,$filo))[0,3,6];
	$llave = $kingdom."_".$phylum."_".$class;
	print "$org ... $llave\n";
	$n_orgs{$llave}++;
        $filas{$llave}= 0;
	$infile = "Analisis_de_RNAhybrid_8dic/".$org.".txt";
	foreach $ren (split(/\n/,`cat $infile`))
		{
		@ele = split(/\t/,$ren);
		$p = $ele[1];
		foreach $i (2..10)
			{
			$acu{$llave}[$p][$i] = $acu{$llave}[$p][$i] + $ele[$i];
                        ($filas{$llave}= $p)  && ($p > $filas{$llave});
			}
		}
	}

foreach $llave (sort %n_orgs)
	{
	print "$llave ..... $n_orgs{$llave} ....\n";
	if ($n_orgs{$llave} > 0)
	{
	$outfile = "Analisis_de_RNAhybrid_por_clase_filogenetica_8dic/".$llave.".txt";
	open(S,">$outfile");

	foreach $i (1..$filas{$llave})
		{
		print S "$llave\t$i\t";
		foreach $j (2..10)
			{
			$n = int($acu{$llave}[$i][$j]*1000000/$n_orgs{$llave}+0.5) / 1000000;
			print S "$n\t";
			}
		print S "\n";
		}
	close(S);
	}
	}
