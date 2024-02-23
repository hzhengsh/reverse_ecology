#!perl -w

use warnings;
use strict;

opendir (DIR, "$ARGV[0]") or die "can't open file $ARGV[0]";
open (USAGE, ">$ARGV[1]") or die "can't create file $ARGV[1]";
open (PROPORTION, ">$ARGV[2]") or die "can't create file $ARGV[2]";

my %codon_table = (
"D" => "Asp",
"E" => "Glu",
"K" => "Lys",
"R" => "Arg",
"H" => "His",
"G" => "Gly",
"A" => "Ala",
"V" => "Val",
"L" => "Leu",
"I" => "Ile",
"M" => "Met",
"F" => "Phe",
"W" => "Trp",
"P" => "Pro",
"N" => "Asn",
"Q" => "Gln",
"S" => "Ser",
"T" => "Thr",
"Y" => "Tyr",
"C" => "Cys",
"X" => "Unknown"
);

foreach my $key (sort keys %codon_table){
	print USAGE "	$codon_table{$key}";
	print PROPORTION "	$codon_table{$key}";
} 
print USAGE "\n";
print PROPORTION "\n";

foreach my $file (readdir DIR){
	if($file ne "." && $file ne ".."){
		open (GENOME, "$ARGV[0]/$file") or die "can't open file $file";
		my $genome = "";
		while(my $line = <GENOME>){
			if($line =~ /^>/){
				next;
			}
			else{
				$line =~ s/\*\s+$|\s+$//ig;
				$genome .= $line;
			}
		}
		close GENOME;
		
		my ($length, $codon_usage) = & amino_acid_count($genome);
		my %codon_usages = %$codon_usage;
		print USAGE "$file";
		print PROPORTION "$file";
		foreach my $key (sort keys %codon_table){
			if(!exists($codon_usages{$key})){
				print USAGE "	0";
				print PROPORTION "	0";
				next;
			}
			
			my $proportion = $codon_usages{$key}/$length;
			print USAGE "	$codon_usages{$key}";
			print PROPORTION "	$proportion";
		}
		print USAGE "\n";
		print PROPORTION "\n";
	}
}
closedir DIR;

sub amino_acid_count{
	my $genome = shift @_;
	my %amino_acid_count = ();
	my @fields = split //, $genome;
	foreach my $item (@fields){
		$amino_acid_count{$item}++;
	}
	return (scalar(@fields),\%amino_acid_count);
}

