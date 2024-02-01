#!/usr/bin/perl
#  Copyright 2015 West Coast Informatics, LLC
#
# Computes transitive closure from a snapshot inferred RF2 relationships file
# Author: Brian Carlsen
#
use strict vars;

#
# Set Defaults & Environment
#
our $badargs;
our $badvalue;
our $isARel = "116680003";
our $root = "138875005";

#
# Check options
#
our @ARGS=();
while (@ARGV) {
  my $arg = shift(@ARGV);
  if ($arg !~ /^-/) {
      push @ARGS, $arg;
      next;
  }
  if ($arg eq "-help" || $arg eq "--help") {
    &PrintHelp;
    exit(0);
  } else {
    $badargs = 1;
    $badvalue = $arg;
  }
}

#
# Handle parameters
#
if (scalar(@ARGS) != 2) {
    $badargs = 3;
    $badvalue = scalar(@ARGS);
}
our ($relsFile, $outputFile) = @ARGS;

#
# Write any arg errors
#
our %errors = (1 => "Illegal switch: $badvalue",
           2 => "Illegal service: $badvalue",
           3 => "Bad number of arguments: $badvalue",
           4 => "$badvalue must be set");
if ($badargs) {
    &PrintUsage;
    print "\n$errors{$badargs}\n";
    exit(1);
}

#
# Begin
#
print "------------------------------------------------------------\n";
print "Starting ...", scalar(localtime),"\n";
print "------------------------------------------------------------\n";
print "IsA rel  : $isARel\n";
print "Rels file   : $relsFile\n";
print "Output file : $outputFile\n";
print "\n";

#
# Load PAR/CHD relationships map.
#
print "    Load PAR/CHD rels ...".(scalar(localtime))."\n";
our %chdPar = ();
our %parChd = ();
our %seen = ();
initRelationships($relsFile);


#
# Write transitive closure file
#
print "    Write transitive closure table ...".(scalar(localtime))."\n";
our $OUT;
open ($OUT, ">$outputFile") || die "Could not open $outputFile: $! $?\n";
print $OUT "superTypeId\tsubTypeId\r\n";
our $code;
our $ct = 0;
foreach $code (keys %parChd) {
    # skip root
    next if $code eq $root;
    $ct++;
    my @descs = getDescendants($code);
    my $desc;
    foreach $desc (@descs) {
        print $OUT "$code\t$desc\r\n";
    }
    if ($ct % 10000 == 0) {
        print "      $ct codes processed ...", scalar(localtime),"\n";
    }
}
close($OUT);

#
# Finish
#
print "------------------------------------------------------------\n";
print "finished ...", scalar(localtime),"\n";
print "------------------------------------------------------------\n";

exit 0;


######################### LOCAL PROCEDURES #######################

#
# Print the usage
#
sub PrintUsage {

        print qq{ This script has the following usage:
   transitiveClosure.pl <relsFile> <outputFile>
};
}

#
# Print help info
#
sub PrintHelp {
        &PrintUsage;
        print qq{
 Parameters
       relsFile:      A snapshot inferred RF2 relationships file
       outputFile:    Output transitive closure file
 Options:
       -[-]help:      On-line help

};
}

#
# Initialize relationships hashes
#
sub initRelationships {
    my($relsFile) = @_;
    my $IN;
    open ($IN, "<$relsFile") || die "Failed to open $relsFile: $! $?\n";
    my $ct = 1;
    # iterate through rels file
    while (<$IN>) {
        chop; chop;
        my ($id, $effectiveTime, $active, $moduleId, $sourceId, $destinationId,
            $relationshipGroup, $typeId, $characteristicTypeId, $modifierId) = split /\t/;
        # skip inactive or non-isa rels
        next unless $typeId eq $isARel;
        next unless $active;
        $ct++;
        # push new child for parent
        push @{$parChd{$destinationId}}, $sourceId;
    }
    print "      $ct relationships loaded\n";
    close($IN);
}

#
# Get descendants of a root
# Input: root id
# Output: array of descendant ids
#
sub getDescendants {
    my($root) = @_;
    # reset seen
    %seen = ();
    my %descendants = helper($root);
    return keys %descendants;
}

#
# Helper routine
#
sub helper {
    my($par) = @_;

    # if we've seen this node already, children are accounted for - bail
    if ($seen{$par}) { return (); }
    $seen{$par} = 1;

    # Get Children of this node
    my @chd = @{$parChd{$par}};

    # If this is a leaf node, bail
    return () if scalar(@chd) == 0;

    # Iterate through children, mark as descendant and recursively call
    my $chd;
    my $chdChd;
    my %descendants = ();
    foreach $chd (@chd) {
        $descendants{"$chd"} = 1;
        my %grandDesc = helper($chd);
        # add all recursively gathered descendants at this level
        foreach $chdChd ( keys %grandDesc) {
            $descendants{"$chdChd"} = 1;
        }
    }

    return %descendants;
}
