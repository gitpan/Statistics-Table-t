package Statistics::Table::t;

use strict;
use vars qw($VERSION @ISA @EXPORT);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(t_significance t);
$VERSION = '0.01';

my @t = ([0.5,  0.7,  0.9,   0.95,  0.99], # Significance levels
	 [1.00, 1.96, 6.31, 12.71, 63.66], # 1 degree of freedom
	 [0.82, 1.39, 2.92, 4.30, 9.92],
	 [0.76, 1.25, 2.35, 3.18, 5.84],   # 3 degrees of freedom
	 [0.74, 1.19, 2.13, 2.78, 4.60],
	 [0.73, 1.16, 2.02, 2.57, 4.02],   # 5 degrees of freedom
	 [0.72, 1.13, 1.94, 2.45, 3.71],
	 [0.71, 1.12, 1.90, 2.37, 3.50],   # 7 degrees of freedom
	 [0.71, 1.11, 1.86, 2.31, 3.36],
	 [0.70, 1.10, 1.83, 2.26, 3.25],   # 9 degrees of freedom
	 [0.70, 1.09, 1.81, 2.23, 3.17], 
	 [0.70, 1.09, 1.80, 2.20, 3.11],   # 11 degrees of freedom
	 [0.70, 1.08, 1.78, 2.18, 3.06], 
	 [0.69, 1.08, 1.77, 2.16, 3.01],   # 13 degrees of freedom
	 [0.69, 1.08, 1.76, 2.14, 2.98], 
	 [0.69, 1.07, 1.75, 2.13, 2.95],   # 15 degrees of freedom
	 [0.69, 1.07, 1.75, 2.12, 2.92], 
	 [0.69, 1.07, 1.74, 2.11, 2.90],   # 17 degrees of freedom
	 [0.69, 1.07, 1.73, 2.10, 2.88],
	 [0.69, 1.07, 1.73, 2.09, 2.86],   # 19 degrees of freedom
	 [0.69, 1.06, 1.72, 2.09, 2.84]);


sub t {
    my ($arrayref, $expected_mean) = @_;
    my ($mean) = mean($arrayref);
    return ($mean - $expected_mean) / sqrt(estimate_variance($arrayref));
}

sub t_significance { 
    my ($t, $degrees, $tails) = @_;
    if ($tails != 1) {
	warn "Only one-tailed t-tests are supported.";
	return undef;
    }
    my ($row) = $t[$degrees];
    my ($lo, $hi) = (0, 1);
    for (my $i = 0; $i < @$row; $i++) {
	if ($row->[$i] < $t) { $lo = $t[0][$i] }
	if ($row->[$i] > $t) {
	    $hi = $t[0][$i];
	    last;
	}
    }

    return ($lo, $hi);
}

sub mean {
    my ($arrayref) = @_;
    my $result;
    foreach (@$arrayref) { $result += $_ }
    return $result / @$arrayref;
}

sub estimate_variance {
    my ($arrayref) = @_;
    my ($mean, $result) = (mean($arrayref), 0);
    foreach (@$arrayref) { $result += ($_ - $mean) ** 2 }
    return $result / $#{$arrayref};
}

1;
__END__

=head1 NAME

Statistics::Table::t - Perl module for the statistical t-test

=head1 SYNOPSIS

  use Statistics::Table::t;

  @data = (3, 4, 3, 6, 3, 2, 8, 10, 4, 5, 6);  # Your data
  $t = t(\@data, 2);                 # The 3 is the mean you were expecting
  ($lo, $hi) = t_significance($t, scalar(@data) - 1, 1);

  print "The probability that your data is not due to chance: \n";
  print "More than $lo and less than $hi. \n";


=head1 DESCRIPTION

Stub documentation for Statistics::Table::t was created by h2xs. It
looks like the author of the extension was negligent enough to leave
the stub unedited.

Actually, he wasn't, but he's amazed that there's no better tool
for creating modules than something designed to convert C headers
files to XS stubs.

=head1 AUTHOR

Jon Orwant, orwant@media.mit.edu

=head1 SEE ALSO

Statistics::ChiSquare

Chapter 15 of Mastering Algorithms in Perl, O'Reilly, 1999.

=cut
