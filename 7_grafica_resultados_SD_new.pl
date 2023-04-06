#!/usr/bin/perl -w

#~ Generate the graphs

foreach $renglon (split(/\n/,`cat colitas_30_16S_new5`))
	{
	($org,$tmp) = split(/\t/,$renglon);
        $colita{$org} = $tmp;
	}

foreach $renglon (split(/\n/,`cat orgs_S21_verificadas`))
	{
	($org,$filo) = split(/\t/,$renglon);
	@x = split(/\,/,$filo);

	print "$x[20]\t";
	$titulo = $x[6]." .. ".$x[20];
	$n++;
	print "$n\t$org\t";
	$colita = $colita{$org};

	$infile = "Analisis_de_RNAhybrid_8dic/".$org.".txt";
	$outfile = "Graficas_SD_8dic/".$org.".svg";
	$mayor = `cat $infile | cut -f3 | sort -n | tail -1`;
	chomp($mayor);
	$divisiones = 200;
        if($mayor <= 90) {$divisiones = 6};
        if($mayor <= 80) {$divisiones = 4};
        if($mayor <= 70) {$divisiones = 4};
	if($mayor <= 60) {$divisiones = 4};
	if($mayor <= 50) {$divisiones = 4};
	if($mayor <= 40) {$divisiones = 4};
	if($mayor <= 30) {$divisiones = 3};
	if($mayor <= 20) {$divisiones = 2};
	if($mayor <= 10) {$divisiones = 0.5};
	if($mayor <= 5) {$divisiones = 0.1};
	if($mayor <= 1) {$divisiones = 0.05};
	if($mayor <= 0.1) {$divisiones = 0.005};
	print "mayor = $mayor ... $divisiones\n";
	&grafica;
	}

sub grafica
{
open(S,">datos_para_grafica.txt");
print S "#\tA\tC\tG\tU\n";
foreach $linea (split(/\n/,`nl $infile | sort -nr | cut -f2-`))
	{
	$i++;
	@ele = split (/\t/,$linea);
$base[$i] = ".";
	if ($ele[7] > $ele[8] && $ele[7] > $ele[9] && $ele[7] > $ele[10] ) {$base[$i] = "A"}
	if ($ele[8] > $ele[7] && $ele[8] > $ele[9] && $ele[8] > $ele[10] ) {$base[$i] = "C"}
	if ($ele[9] > $ele[7] && $ele[9] > $ele[8] && $ele[9] > $ele[10] ) {$base[$i] = "G"}
	if ($ele[10] > $ele[7] && $ele[10] > $ele[8] && $ele[10] > $ele[9] ) {$base[$i] = "U"}
	print S "$base[$i]\t$ele[3]\t$ele[4]\t$ele[5]\t$ele[6]\n";
	}
close(S);

open(I,">instru");
print I "set terminal svg\n";
print I "set output \'$outfile\'\n";
print I "set title \"$titulo\"\n";
	print I "set key right\n";
print I "set grid y\n";
print I "set style data histograms\n";
print I "set style histogram rowstacked\n";
print I "set boxwidth 0.5\n";
print I "set style fill solid 1.0 border -1\n";
print I "set ytics $divisiones nomirror\n";
print I "set yrange [:$mayor]\n";
print I "set ylabel \"Percentage (%)\"\n";
print I "set ytics $divisiones\n";

print I "plot \'datos_para_grafica.txt\' using 2 t \"A\", \'\' using 3 t \"C\",  \'\' using 4 t \"G\", \'\' using 5:xtic(1) t \"T\"\n";
close(I);
 system "gnuplot < instru";
}
