#!/usr/bin/perl -w
use strict;

#Perform installation of gbrowse apache configuration files

use File::Copy;
use Bio::Root::IO;

# get configuration stuff from command line
my $dir = $ARGV[0];

# use Bio::Root::IO now
#my $delim = '/';
#if ($Config{'osname'} =~ /win/i && $Config{'osname'} !~ /darwin/i ) {
#    $dir =~ s!\/!\\!g;
#    $delim = '\\';    
#}

#start the installation...
print "Installing sample configuration files...\n";

if (! (-e $dir)) {
    mkdir($dir,0777) or die "unable to make $dir directory\n";
}

opendir CONFDIR, "conf" or die "unable to opendir conf\n";
while (my $conffile = readdir(CONFDIR) ) {
    my $localfile = Bio::Root::IO->catfile('conf', $conffile);
    if (-f $localfile) {
        my $installfile = Bio::Root::IO->catfile($dir, $conffile);
        if (-f $installfile) {
	    print "   Found $conffile in $dir. Skipping...\n";
        } else {
	    copy($localfile, $installfile) 
                or die "unable to copy to $installfile\n";
        }
    }
}
closedir CONFDIR;

my $plugindir = Bio::Root::IO->catfile($dir, "plugins");
if (! (-e $plugindir)) {
    mkdir($plugindir,0777) or die "unable to mkdir $plugindir\n";
}


opendir PLUGINS, "conf/plugins" or die "unable to opendir ./conf/plugins\n";
while (my $pluginfile = readdir(PLUGINS) ) {
    my $localfile = Bio::Root::IO->catfile('conf/plugins',$pluginfile);
    if (-f $localfile) {
        my $installfile = Bio::Root::IO->catfile($plugindir, $pluginfile);
	chmod (0666, $installfile);
        copy($localfile, $installfile) 
            or die "$localfile unable to copy to $installfile : $!\n";
	chmod (0644, $installfile);
    } 
}
closedir PLUGINS;

my $langdir = Bio::Root::IO->catfile($dir, 'languages');
if (! (-e $langdir)) {
    mkdir($langdir,0777) or die "unable to mkdir $langdir\n";
}

opendir LANGS, "conf/languages" or die "unable to opendir ./conf/languages\n";
while (my $langfile = readdir(LANGS)) {
    my $localfile = Bio::Root::IO->catfile("conf/languages", $langfile);
    if (-f $localfile) {
        my $installfile = Bio::Root::IO->catfile($langdir, $langfile);
        chmod (0666, $installfile);
        copy($localfile, $installfile) 
            or die "unable to copy to $installfile\n";
        chmod (0644, $installfile);
    }
}
closedir LANGS;


