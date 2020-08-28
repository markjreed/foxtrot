#!/usr/bin/env perl
use strict;
use warnings;

die "Usage: $0 filename\n" unless @ARGV == 1;

my @program = load($ARGV[0]);
die "$0: $ARGV[0]: Cannot load file.\n" unless @program;

run(@program);
exit 0;

sub load {
  my $file = shift;
  if (open my $fh, '<', $file) {
    return map { split } <$fh>;
  } else {
    return;
  }
}

sub run {
  my @memory = @_;
  my $ip = 0;
  while ($ip >= 0 && $ip < @memory) {
    my ($a, $b, $c) = @memory[$ip,$ip+1,$ip+2];
    $ip += 3;
    if ($a < 0) {
      $memory[$b] = ord(getc);
    } elsif ($b < 0) {
      print chr($memory[$a]);
    } else {
      if (($memory[$b] -= $memory[$a]) <= 0) {
        $ip = $c;
      }
    }
  }
}
