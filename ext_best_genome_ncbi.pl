#!/usr/bin/perl -w
use strict;

my (%lines, %HQ_genome);
my $file_to_open= shift; # assembly_summary.paths

open IN, $file_to_open or die "Cant read $file_to_open\n"; 
while(<IN>){
    chomp;
    %lines= ();
    %HQ_genome= ();
    my $HQ= 0;
    my $file_to_open2= $_;
    (my $org= $file_to_open2)=~s/\.\/([^\/]+).*/$1/;
    open IN2, $file_to_open2 or die "Cant read $file_to_open2\n"; 
    while(<IN2>){
        next if /^#/;
        chomp;
        if( /^.*\s+strain=([^\t]+)\s+latest.*\s+(\d+)\/\d{2}\/\d{2}/ ){
            my ($strain, $year)= ($1, $2);
            ($strain= $strain)=~s/ /_/g;
            if( /^.*\s+latest/ && /^.*\s+Genome/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{genome}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Chromosome/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{chromosome}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Scaffold/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{scaffold}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Contig/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{contig}= $1;                
            }
            if( /^.*\s+reference genome\s+.*/ && /^.*\s+(ftp\S+)/ ){
                $HQ_genome{$strain}{reference}= $1;
                $HQ_genome{$strain}{year}= $year;
            }
            if( /^.*\s+representative genome\s+.*/ && /^.*\s+(ftp\S+)/ ){
                $HQ_genome{$strain}{representative}= $1;
                $HQ_genome{$strain}{year}= $year;
            }
            
        }elsif(  /^.*\s+([^\t]+)\s+latest.*\s+(\d+)\/\d{2}\/\d{2}/ ){ # solo por unos pocos (287 de 13208) que no tienen la nomenclatura "strain=" solo tienen el nombre del strain. ver: lista_sin_strain.txt
            my ($strain, $year)= ($1, $2);
            if( /^.*\s+latest/ && /^.*\s+Genome/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{genome}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Chromosome/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{chromosome}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Scaffold/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{scaffold}= $1;
            }elsif( /^.*\s+latest/ && /^.*\s+Contig/ && /^.*\s+(ftp\S+)/ ){
                $lines{$year}{$strain}{contig}= $1;                
            }
            if( /^.*\s+reference genome\s+.*/ && /^.*\s+(ftp\S+)/ ){
                $HQ_genome{$strain}{reference}= $1;
                $HQ_genome{$strain}{year}= $year;
            }
            if( /^.*\s+representative genome\s+.*/ && /^.*\s+(ftp\S+)/ ){
                $HQ_genome{$strain}{representative}= $1;
                $HQ_genome{$strain}{year}= $year;
            }
            
        }
        
        
    }

    foreach my $strain ( sort keys %HQ_genome ){
        $HQ_genome{$strain}{reference} ? (print "$org\t$strain\treference\t$HQ_genome{$strain}{year}\t$HQ_genome{$strain}{reference}\n") : (print "$org\t$strain\trepresentative\t$HQ_genome{$strain}{year}\t$HQ_genome{$strain}{representative}\n");
        $HQ++;
    }
	
    unless ($HQ){
    OUTER:
      foreach my $year ( sort {$b<=>$a} keys %lines ){
        foreach my $strain ( sort keys $lines{$year} ){
            if( $lines{$year}{$strain}{genome} ){
                print "$org\t$strain\tGenome\t$year\t$lines{$year}{$strain}{genome}\n";
                last OUTER;
            }
        }
        foreach my $strain ( sort keys $lines{$year} ){
            if( $lines{$year}{$strain}{chromosome} ){
                print "$org\t$strain\tChrm\t$year\t$lines{$year}{$strain}{chromosome}\n";
                last OUTER;
            }    
        }
        foreach my $strain ( sort keys $lines{$year} ){
            if( $lines{$year}{$strain}{scaffold} ){
                print "$org\t$strain\tScaff\t$year\t$lines{$year}{$strain}{scaffold}\n";
                last OUTER;
            }
        }
        foreach my $strain ( sort keys $lines{$year} ){
            if( $lines{$year}{$strain}{contig} ){
                print "$org\t$strain\tContig\t$year\t$lines{$year}{$strain}{contig}\n";
                last OUTER;
            }
        }
            
        }
        
      }
    
}
