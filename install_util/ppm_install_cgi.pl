#!/usr/bin/perl -w
use strict;
use File::Copy;
use Bio::Root::IO;

foreach (@ARGV) {
  $_ =~ s/^\'(.*)\'$/$1/;
}

my %options = map {split /=/} @ARGV;
my $cgi_target = $options{CGIBIN};

print "Installing gbrowse CGI scripts...\n";

if (! (-e $cgi_target) ) {
    mkdir($cgi_target,0777) or die "unable to create $cgi_target directory\n";
}

chdir 'cgi-bin';
foreach (glob('*')) {
  next if /README/;
  next if /CVS/;
  next if /^[.\#]/;
  next if /~$/;
  next if /\.PLS$/;
  next unless (-f $_);
  my $installfile = Bio::Root::IO->catfile($cgi_target, $_);
  warn "copying $_ to $installfile";
  copy($_, $installfile ) or die "unable to copy to $installfile\n";
  my $mode = 0755;
  chmod $mode, $installfile
    or die "unable to make $installfile world executable\n";
}
