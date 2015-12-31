#!/usr/local/bin/perl
# replace spaces in all filenames with underscores

$dir = ".";

opendir(DIR, $dir) || die "Can't open $dir\n";
for (readdir(DIR)) {
  next if $_ eq '.';
  next if $_ eq '..';
  next if $_ eq 'lost+found';
  $newfile = $_;
  $newfile =~ s/ //g;
  $newfile =~ s/-//g;
  rename $_, $newfile;
}