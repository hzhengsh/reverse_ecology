#!perl -w

use warnings;
use strict;

opendir (FASTADIR,"$ARGV[0]") or die "can't open file $ARGV[0]";
open (IVYWREL,">$ARGV[1]") or die "can't create file $ARGV[1]";

foreach my $file (readdir FASTADIR){
	if($file ne "." && $file ne ".."){
		open (IN, "$ARGV[0]/$file") or die "can't open file $file";
		my $seq = "";
		while(my $line = <IN>){
			if($line =~ /^>/){next;}
			else{
				$line =~ s/^\s+|\s+$//ig;
				$seq .= $line;
			}
		}
		close IN;
		my $length = length($seq);
		my $n_I = $seq =~ s/I/I/ig;
		my $n_V = $seq =~ s/V/V/ig;
		my $n_Y = $seq =~ s/Y/Y/ig;
		my $n_W = $seq =~ s/W/W/ig;
		my $n_R = $seq =~ s/R/R/ig;
		my $n_E = $seq =~ s/E/E/ig;
		my $n_L = $seq =~ s/L/L/ig;
	
		my $IVYWREL = ($n_I+$n_V+$n_Y+$n_W+$n_R+$n_E+$n_L)/$length;
		my $ogt = $IVYWREL*937-335;
		print IVYWREL "$file	$IVYWREL	$ogt\n";
	}
}

close IVYWREL;
closedir FASTADIR;