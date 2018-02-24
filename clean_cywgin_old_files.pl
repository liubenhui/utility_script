#!/usr/bin/env perl

# 删除cygwin下载的旧版本文件，必须在cygwin环境下运行
# by liubenhui@2018-02-01

use strict;
use warnings;

use File::Basename;

my @files = split '\n', `find . -type f | sort`;
print "cygwin file count=" . @files . "\n";

my ($currfile, $nextfile);
for (my $i = 0; $i < @files - 1; $i++) {
	$currfile = $files[$i];
	$nextfile = $files[$i + 1];

	my ($currname, $nextname) = ($currfile, $nextfile);
	my ($currdirname, $nextdirname, $currbasename, $nextbasename);
	$currdirname  = dirname($currfile);
	$nextdirname  = dirname($nextfile);
	$currbasename = basename($currfile);
	$nextbasename = basename($nextfile);

	$currbasename =~ s/\d/#/g;
	$nextbasename =~ s/\d/#/g;

	if ($currdirname eq $nextdirname && $currbasename eq $nextbasename) {
		if ($currfile lt $nextfile) {
			print "$currfile => $currdirname/$currbasename\n";
			print "$nextfile => $nextdirname/$nextbasename\n";
			print "rm $currfile\n" if unlink $currfile;
		}
	}
}

