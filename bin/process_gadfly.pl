#!/usr/bin/perl


if ($ARGV[0]=~/^-?-h/i) {
die <<'USAGE';

This script massages the RELEASE 3 Flybase/Gadfly GFF file located at
http://www.fruitfly.org/sequence/sequence_db/whole-genome_annotation-feature-region_dmel_RELEASE3.GFF
into the "correct" version of the GFF format.

To use this script, download the Gadfly GFF file and save it to disk.
Then run this script on the file:

 % process_gadfly.pl whole-genome_annotation-feature-region_dmel_RELEASE3.GFF > fly.gff

To load the fly DNA, download the FASTA format file for the
corresponding release in chromosome arm format
(e.g. http://www.fruitfly.org/sequence/sequence_db/na_whole-genome_genomic_dmel_RELEASE3.FASTA).

The gadfly.gff file and the fasta fiile can now be loaded into a Bio::DB::GFF database
using the following command:

  % bulk_load_gff.pl -d fly -fasta na_whole-genome_genomic_dmel_RELEASE3.FASTA fly.gff 

(Where "fly" is the name of the database.  Change it as appropriate.
The database must already exist and be writable by you!)

The resulting database will have the following feature types
(represented as "method:source"):

  Component:arm              A chromosome arm
  Component:scaffold	     A chromosome scaffold (accession #)
  Component:gap	             A gap in the assembly
  clone:clonelocator         A BAC clone
  gene:gadfly                A gene accession number
  transcript:gadfly          A transcript accession number
  translation:gadfly         A translation
  codon:gadfly               Significance unknown
  exon:gadfly                An exon
  symbol:gadfly              A classical gene symbol
  similarity:blastn          A BLASTN hit
  similarity:blastx          A BLASTX hit
  similarity:sim4            EST->genome using SIM4
  similarity:groupest        EST->genome using GROUPEST
  similarity:repeatmasker    A repeat

IMPORTANT NOTE: This script will *only* work with the RELEASE3 gadfly
files and will not work with earlier releases.

USAGE
;
}

use strict;

while (<>) {
  next if /^\#/;
  chomp;
  my ($ref,$csource,$cmethod,$start,$stop,$cscore,$strand,$cphase,$cgroup) = split "\t";
  next if $start > $stop;  # something wrong. Don't bother fixing it.

  my $fixed_group = fix_group($csource,$cmethod,$cgroup);
  print join("\t",$ref,$csource,$cmethod,$start,$stop,$cscore,$strand,$cphase,$fixed_group),"\n";
  dump_symbol($ref,$csource,$cmethod,$start,$stop,$cscore,$strand,$cphase,$cgroup) if $cgroup =~ /symbol/i;
}

sub fix_group {
  my ($source,$method,$group) = @_;
  my (@group,$gene);
  push @group,"Transcript $1" if $group =~ /transgrp=([^; ]+)/;
  push @group,"Gene $1"       if $method eq 'gene' && $group =~ /genegrp=([^; ]+)/;

  $gene ||= qq(Note "FlyBase $1")  if $group =~ /dbxref=FlyBase:(\w+)/;
  $gene ||= qq(Note "GadFly $1")   if $group =~ /genegrp=([^; ]+)/;
  push @group,qq(Note "Symbol $1") if $group =~ /symbol=([^; ]+)/ && "Gene $1" ne $group[0];
  push @group,$gene;
  return join ' ; ',@group;
}

# called when we encounter a gene symbol
sub dump_symbol {
  my ($ref,$csource,$cmethod,$start,$stop,$cscore,$strand,$cphase,$cgroup) = @_;
  my ($symbol) = $cgroup=~/symbol=([^;]+)/;
  my ($gene)   = $cgroup=~/genegrp=([^;]+)/;
  return if $symbol eq $gene;
  $cmethod = 'symbol';
  print join("\t",$ref,$csource,$cmethod,$start,$stop,$cscore,$strand,$cphase,qq(Symbol "$symbol")),"\n";
}

__END__

=head1 NAME

process_gadfly.pl - Massage Gadfly/FlyBase GFF files into a version suitable for the Generic Genome Browser

=head1 SYNOPSIS

  % process_gadfly.pl ./RELEASE2 > gadfly.gff

=head1 DESCRIPTION

This script massages the RELEASE 3 Flybase/Gadfly GFF file located at
http://www.fruitfly.org/sequence/sequence_db/whole-genome_annotation-feature-region_dmel_RELEASE3.GFF
into the "correct" version of the GFF format.

To use this script, download the Gadfly GFF file and save it to disk.
Then run this script on the file:

 % process_gadfly.pl whole-genome_annotation-feature-region_dmel_RELEASE3.GFF > fly.gff

To load the fly DNA, download the FASTA format file for the
corresponding release in chromosome arm format
(e.g. http://www.fruitfly.org/sequence/sequence_db/na_whole-genome_genomic_dmel_RELEASE3.FASTA).

The gadfly.gff file and the fasta fiile can now be loaded into a Bio::DB::GFF database
using the following command:

  % bulk_load_gff.pl -d fly -fasta na_whole-genome_genomic_dmel_RELEASE3.FASTA fly.gff 

(Where "fly" is the name of the database.  Change it as appropriate.
The database must already exist and be writable by you!)

The resulting database will have the following feature types
(represented as "method:source"):

  Component:arm              A chromosome arm
  Component:scaffold	     A chromosome scaffold (accession #)
  Component:gap	             A gap in the assembly
  clone:clonelocator         A BAC clone
  gene:gadfly                A gene accession number
  transcript:gadfly          A transcript accession number
  translation:gadfly         A translation
  codon:gadfly               Significance unknown
  exon:gadfly                An exon
  symbol:gadfly              A classical gene symbol
  similarity:blastn          A BLASTN hit
  similarity:blastx          A BLASTX hit
  similarity:sim4            EST->genome using SIM4
  similarity:groupest        EST->genome using GROUPEST
  similarity:repeatmasker    A repeat

IMPORTANT NOTE: This script will *only* work with the RELEASE3 gadfly
files and will not work with earlier releases.

=head1 SEE ALSO

L<Bio::DB::GFF>, L<bulk_load_gff.pl>, L<load_gff.pl>

=head1 AUTHOR

Lincoln Stein <lstein@cshl.org>.

Copyright (c) 2002 Cold Spring Harbor Laboratory

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  See DISCLAIMER.txt for
disclaimers of warranty.

=cut


