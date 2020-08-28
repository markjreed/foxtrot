#!/usr/bin/env perl
use v5.14;
my $DEBUG = 0;
my $program;
{ 
  local $/ = undef; 
  $program = <ARGV>;
};
$program =~ s/[^][.,<>+-]//g;
my @program = split //, $program;
my %matches;
my @loops;
for (my $pc=0; $pc<@program; ++$pc) {
  my $ins = $program[$pc];
  if ($ins eq '[') {
    push @loops, $pc;
  } elsif ($ins eq ']') {
    my $match = pop @loops or die "$0: unmatched ] at instruction $pc\n";
    $matches{$pc} = $match;
    $matches{$match} = $pc;
  }
}

my @memory = (0);
my $pc = 0;
my $mp = 0;
while ($pc < @program) {
  my $ins = $program[$pc];
  $pc++;
  if ($ins eq '[') {
    if (!$memory[$mp]) {
      $pc = $matches{$pc-1}+1;
    }
  } elsif ($ins eq ']') {
    if ($memory[$mp]) {
      $pc = $matches{$pc-1}+1
    }
  } elsif ($ins eq '<') {
    $mp--;
    while ($mp < 0) {
      unshift @memory, 0;
      $mp++;
    }
  } elsif ($ins eq '>') {
    $mp++;
    push @memory, 0 while $mp >= @memory;
  } elsif ($ins eq '-') {
    $memory[$mp] = ($memory[$mp] - 1) % 256;
  } elsif ($ins eq '+') {
    $memory[$mp] = ($memory[$mp] + 1) % 256;
  } elsif ($ins eq '.') {
    print chr($memory[$mp]);
  } elsif ($ins eq ',') {
    $memory[$mp] = ord(getc);
    debug("Read '${\($memory[$mp])}'\n");
  }
}

sub debug {
  warn @_ if $DEBUG;
}
