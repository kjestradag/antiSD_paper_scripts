#!/usr/bin/perl -w

#~ Generate the graphs for the classes

foreach $renglon (split(/\n/,`ls Analisis_de_RNAhybrid_por_clase_filogenetica_8dic`))
	{
	($gpo) = split(/\./,$renglon);
	$titulo = $gpo;
	$titulo =~ tr/_/ /;
	$infile = "Analisis_de_RNAhybrid_por_clase_filogenetica_8dic/".$renglon;
	$outfile = "Graficas_SD_por_clase_filogenetica_8dic/".$gpo.".svg";
print "renglon:$renglon\ninfile:$infile\noutfile:$outfile\n";
	$mayor = `cat $infile | cut -f3 | sort -n | tail -1`;
	chomp($mayor);
print "mayor $mayor\n";
        if($mayor <= 60) {$divisiones = 6};
        if($mayor <= 50) {$divisiones = 5};
        if($mayor <= 40) {$divisiones = 4};
        if($mayor <= 30) {$divisiones = 3};
        if($mayor <= 20) {$divisiones = 1};
        if($mayor <= 10) {$divisiones = 0.5};
        if($mayor <= 5)  {$divisiones = 0.25};
        if($mayor <= 1)  {$divisiones = 0.05};
        if($mayor <= 0.1) {$divisiones = 0.005};
        print "mayor = $mayor ... $divisiones\n";
	&grafica;
	}

sub grafica
{
open(S,">datos_para_grafica.txt");
print S "#\tA\tC\tG\tU\n";
foreach $linea (split(/\n/,`nl $infile | sort -nr |  cut -f2-`))
	{
	$i++;
	@ele = split (/\t/,$linea);
	if ($ele[7] > $ele[8] && $ele[7] > $ele[9] && $ele[7] > $ele[10] ) {$base[$i] = "A"}
	if ($ele[8] > $ele[7] && $ele[8] > $ele[9] && $ele[8] > $ele[10] ) {$base[$i] = "C"}
	if ($ele[9] > $ele[7] && $ele[9] > $ele[8] && $ele[9] > $ele[10] ) {$base[$i] = "G"}
	if ($ele[10] > $ele[7] && $ele[10] > $ele[8] && $ele[10] > $ele[9] ) {$base[$i] = "U"}
	print S "$base[$i]\t$ele[3]\t$ele[4]\t$ele[5]\t$ele[6]\n";
	}
close(S);

$scale = 1063.0/420.0;
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
