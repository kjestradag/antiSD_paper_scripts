#!/usr/bin/perl -w
use strict;

my $file_to_open= shift; # recibe el  org_vs_taxIds.txt ex:
# Escherichia_coli  511145  K-12_substr._MG1655
# Sphingobacterium_spiritivorum 525373  ATCC_33861
# Paenibacillus_sp._FSL_H7-0357 1536774 FSL_H7-0357
# Demequina_aurantiaca  676200  NBRC_106265

open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
    my($org, $taxid, $strain)= (split)[0,1,2];
    my $urlcore= "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/";
    my $url_taxid= "wwwtax.cgi?mode=Undef&id=$taxid";
    my ($superkingdom, $phylum, $class, $order, $family, $genus, $species);

    system("wget \"$urlcore$url_taxid\"");

    open IN2, $url_taxid or die "Cant read $url_taxid\n";
    open OUT, ">${org}_-_$strain/taxonomy.txt" || die "can't write taxonomy.txt";
    while(<IN2>){
        if( /^.*superkingdom">([^<]+)/ ){
            $superkingdom= $1;
        }
        if( /^.*phylum">([^<]+)/ ){
            $phylum= $1;
        }
        if( /^.*class">([^<]+)/ ){
            $class= $1;
        }
        if( /^.*order">([^<]+)/ ){
            $order= $1;
        }
        if( /^.*family">([^<]+)/ ){
            $family= $1;
        }
        if( /^.*genus">([^<]+)/ ){
            $genus= $1;
        }
        if( /^.*species">([^<]+)/ ){
            $species= $1;
        }
    }
    $superkingdom ||= 'NA';
    $phylum ||= 'NA';
    $class ||= 'NA';
    $order ||= 'NA';
    $family ||= 'NA';
    $genus ||= 'NA';
    $species ||= 'NA';

    print OUT "Organism\tTaxID\tSuperkingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n$org\t$taxid\t$superkingdom\t$phylum\t$class\t$order\t$family\t$genus\t$species\n";
    unlink $url_taxid;
}

