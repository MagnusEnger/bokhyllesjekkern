#!/opt/local/bin/perl -w

# Copyright 2010 Magnus Enger Libriotech
#  
# This file is part of Bokhyllesjekker'n.
#  
# Bokhyllesjekker'n is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#  
# Bokhyllesjekker'n is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#  
# You should have received a copy of the GNU General Public License
# along with Bokhyllesjekker'n. If not, see <http://www.gnu.org/licenses/>.
#  
# Source code available from:
# http://github.com/MagnusEnger/bokhyllesjekkern/

use Getopt::Long;
use File::Slurp;
use Data::Dumper;
use Pod::Usage;
use strict;
use diagnostics;

# Get options
my ($bokhyllafile, $isbnfile, $verbose) = get_options();

# Check that the file exists
if (!-e $bokhyllafile) {
  print "The file $bokhyllafile does not exist...\n";
  exit;
}
if (!-e $isbnfile) {
  print "The file $isbnfile does not exist...\n";
  exit;
}

my %bokhylla_isbns;

# Read the file from bokhylla
my @bokhylla = read_file($bokhyllafile);
foreach my $bokhyllaline (@bokhylla) {
	# Skip lines starting with #
	next if (substr($bokhyllaline, 0, 1) eq '#');
	# Split on |
	my ($no, $urn, $oaiids, $sesamids, $isbn, $pages, $title, $creator) = split(/\|/, $bokhyllaline);
	if ($isbn) {
		$isbn =~ s/-//g;
		# DEBUG print $isbn, "\n";
		$bokhylla_isbns{$isbn} = $title;
	}
}

# DEBUG print Dumper %bokhylla_isbns;

my $matches = 0;

# Walk through the file of ISBNs
my @isbns = read_file($isbnfile);
foreach my $isbn (@isbns) {
	$isbn =~ s/-//g;
	$isbn =~ s/ //g;
	$isbn =~ s/\n//g;
	if ($bokhylla_isbns{$isbn}) {
		if ($verbose) {
			print $isbn, ": ", $bokhylla_isbns{$isbn}, "\n";
		}
		$matches++;
	}
}

# Print out the number of matches
print "\nFound $matches matches in $bokhyllafile and $isbnfile\n";

sub get_options {

  # Options
  my $bokhyllafile = '';
  my $isbnfile = '';
  my $verbose = '';
  my $help = '';
  
  GetOptions (
    'b|bokhyllafile=s' => \$bokhyllafile, 
    'i|isbnfile=s' => \$isbnfile, 
    'v|verbose' => \$verbose, 
	'h|?|help'  => \$help
  );

  pod2usage(-exitval => 0) if $help;
  pod2usage( -msg => "\nMissing Argument: -b, --bokhyllafile required\n", -exitval => 1) if !$bokhyllafile;
  pod2usage( -msg => "\nMissing Argument: -i, --isbnfile required\n", -exitval => 1) if !$isbnfile;

  return ($bokhyllafile, $isbnfile, $verbose);

}

__END__

=head1 NAME
    
bokhylla.pl - Compare the contents of "bokhylla" to a file of ISBNs .
        
=head1 SYNOPSIS
            
./bokhylla.pl -i bokhylla.txt -s isbns.txt
               
=head1 OPTIONS
              
=over 4
                                                   
=item B<-b, --bokhyllafile>

Name of the file from Bokhylla to be read, see http://nb.no/nbdigital/bokliste/

=item B<-i, --isbnfile>

File containing the ISBNs, one pr line. 

=item B<-v, --verbose>

Verbose output, including found ISBNs and titles.

=item B<-h, -?, --help>
                                               
Prints this help message and exits.

=back
                                                               
=cut