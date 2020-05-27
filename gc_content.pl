#!/usr/bin/perl -w
use strict;

my ($cnt, $all);

my $file_to_open= shift;  
open IN, $file_to_open or die "Cant read $file_to_open\n"; 
while(<IN>){
    next if /^>/;
    chomp;
	$cnt+= $_=~ tr/GgCc//;
    $all+= length($_);    
}

print "GC content: ",sprintf( "%2.2f\t", $cnt/$all), "\n";
