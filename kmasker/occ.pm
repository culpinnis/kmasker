package kmasker::occ;
use Exporter qw(import);
use jellyfish;
use File::Basename;
use kmasker::filehandler;
use POSIX qw/ceil/;
use strict;
use warnings;
our @ISA = qw(Exporter);
our @EXPORT = qw(normalize_occ);
our @EXPORT_OK = qw(make_occ normalize_occ);


#sub make_index{
#	$file = $_[1]
#	$mer = $_[2]
#	$c = $_[3]
#	$size = $_[4]
#	$threads = $_[5]
#} # Do this step external? # Maybe the workflow implementation from RNA-Seq-Pipeline

sub make_occ{
	my $file=$_[0];
	my $index=$_[1];
	my $mer=$_[2];
	(my $name,my $path,my $suffix) = fileparse($file);
	open(my $fasta, "<", "$file") or die "Can not open $file\n";
	open(my $occ, ">", $path.$name.".occ") or die "Can not write to " . $path.$name.".occ\n";
	my $qmerfile = jellyfish::QueryMerFile->new($index);
	my $seqname="";
	my %seqdata;
	while (read_sequence($fasta, \%seqdata)) {
			print $occ ">".$seqdata{header}."\n";
			#calculate the values for the occ file
			my $overhead = $mer - 1;
			my @values;
			$values[(length($seqdata{seq})-$overhead)..length($seqdata{seq})]=0;
			for (my $i = 0; $i < (length($seqdata{seq})-$overhead); $i++) { #q means query
				#print $i . " : " ;
				#we have to differentiate genome and reads in the future, because reads are canonicalized
				my $kmer = substr($seqdata{seq}, $i, $mer);
				print "$kmer :";
				my $qkmer = jellyfish::MerDNA->new($kmer);
				my $count = $qmerfile->get($qkmer);
				print  " $qkmer : $count \n";
				$values[$i]=$count
			}
			print $occ "@values\n";
	}
	close($fasta);
	close($occ);
}

sub normalize_occ{
	my $file = $_[0];
	my $depth = $_[1];
	my %seqdata;
	(my $name,my $path,my $suffix) = fileparse($file, qr/\.[^.]*/);
	open(my $occ, "<", "$file") or die "Can not open $file\n";
	open(my $occ_norm, ">", $path.$name."_normalized.occ") or die "Can not write to " . $path.$name."_normalized.occ\n";
	if ($depth == 1) {
		print "Nothing to do! Depth was 1. \n";
		return;
	}
	else {
	while (read_occ($occ, \%seqdata)) {
		print $occ_norm ">".$seqdata{header}."\n";
		my @values = split /\s+/ , $seqdata{seq};
		foreach(@values) {
			#print $_ . ": $depth = " . ceil($_/$depth) . "\n" ;
			$_ = ceil($_/$depth);

			}
		print $occ_norm "@values\n";
		}
	}
}

1;