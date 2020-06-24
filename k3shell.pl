#!/usr/bin/perl
use strict;
use warnings;
#system("kubectl apply -f ~/c2/statefulset.yml");
#sleep(15);
# ^ We want that, no??????

my @buff = `kubectl describe pods --namespace clj-ctrl`;   # *must* run Perl as sudo

chomp @buff;

my @ips = ();
my $found = undef;
foreach  (@buff) {
  if($_ =~ m/IP\:.*/ ) # tested on junk pattern -- it doesn't need null coalescing
    {
      $found = $_;
      my ($n1, $n2,$n3,$n4) = ($found =~ /(\d*)\.(\d*)\.(\d*)\.(\d*)/); # could extract on one line?
      push(@ips, "$n1.$n2.$n3.$n4")
    }
}
my @unique = do { my %seen; grep { !$seen{$_}++ } @ips }; # hash logic, no?
#$ENV{'podIps'} = join(',', @unique);
my $bashEnvCmd = "export PODIPS=" . join(',', @unique);

# the following can be used to set ENV vars via "eval $(sudo perl k3shell.pl)"
print "$bashEnvCmd"; # no quotes?

# later, for DSL: cpanm Class::Multimethods::Pure
