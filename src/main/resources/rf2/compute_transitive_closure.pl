#!/usr/bin/perl
# Copyright 2024 West Coast Informatics, Inc
#
# Computes transitive closure from a snapshot inferred RF2 relationships file.
#
use strict vars;

#
# Set Defaults & Environment
#
our $badargs;
our $badvalue;
our $isaRel = "116680003";
our $root = "138875005";
our $history = "";
our $force = 0;
our $self = 1;

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
  if ($arg eq "--history-min") {
    $history = "min";
    next;
  } elsif ($arg eq "--history-mod") {
    $history = "mod";
    next;
  } elsif ($arg eq "--history-max") {
    $history = "max";
    next;
  } elsif ($arg eq "--noself") {
    $self = 0;
    next;
  } elsif ($arg eq "--force") {
    $force = 1;
    next;
  } elsif ($arg eq "--help") {
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
if (scalar(@ARGS) != 1) {
    $badargs = 3;
    $badvalue = scalar(@ARGS);
}
our ($relsFile) = @ARGS;
our $outputFile = "$relsFile";
$outputFile =~ s/_Relationship_/_TransitiveClosure_/;

# Check output file
if (-e "$outputFile") {
    if ($force) {
    unlink $outputFile;
    } else {
          die "Output file already exists: $outputFile\n";
    }
}

# Check history file
our $historyFile = "";
if ($history) {
    # Attempt to find the Association refset
    $historyFile = "$relsFile";
    $historyFile =~ s/sct2_Relationship_/der2_cRefset_Association/;
    if ($historyFile =~ /^der2/) {
        $historyFile =~ s/^/..\/Refset\/Content\//;
    } elsif ($historyFile =~ /Terminology/) {
        $historyFile =~ s/Terminology/Refset\/Content/;
    } else {
        die "Unable to determine path to Association refset file from relationships file = $relsFile\n";
    }
    if (! -e $historyFile) {
        die "Computed path to Association refset file does not exist =  $historyFile\n";
    }
}


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
print "Isa rel      : $isaRel\n";
print "Rels file    : $relsFile\n";
print "Self         : $self\n";
print "Output file  : $outputFile\n";
if ($history) {
  print "History      : $history\n";
  print "History file : $historyFile\n";
}
print "\n";

#
# Load PAR/CHD relationships map.
#
print "    Load PAR/CHD rels ...".(scalar(localtime))."\n";
our %codes = ();
our %parChd = ();
our %seen = ();
our $eol = "\n";
initRelationships($relsFile, $historyFile);

#
# Write transitive closure file
#
print "    Write transitive closure table ...".(scalar(localtime))."\n";
our $OUT;
open ($OUT, ">$outputFile") || die "Could not open $outputFile: $! $?\n";
print $OUT "superTypeId\tsubTypeId\tdepth$eol";
our $code;
our $ct = 0;
foreach $code (keys %codes) {
    # skip root
    next if $code eq $root;
    $ct++;

    # short circuit for leaf nodes
    if (!$parChd{$code} && $self) {
        print $OUT "$code\t$code\t0$eol";
    }

    # otherwise, gather descendants
    else {
        %seen = ();
        my %descs = getDescendants($code, 1);
        my $desc;
        foreach $desc (keys %descs) {
			if (!$self && !($descs{$desc}-1)) {
				next;
			}
            print $OUT "$code\t$desc\t".($descs{$desc}-1)."$eol";
        }
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

        print qq{
Usage: compute-transitive-closure.pl [--help] [--force] [--history-{min,mod,max}] <relsFile>
  e.g. compute-transitive-closure.pl --history-min --noself
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
 Options:
       --force      :   If output file already exists, remove it and proceed
       --history-min:   Add historical relationships to support ECL HISTORY-MIN profile
       --history-mod:   Add historical relationships to support ECL HISTORY-MOD profile
       --history-max:   Add historical relationships to support ECL HISTORY-MAX profile
       --help:          On-line help

};
}

#
# Initialize relationships hashes
#
sub initRelationships {
    my($relsFile, $historyFile) = @_;
    my $IN;

    # expand the wildcard chars in $relsFile
    my @files = glob($relsFile);
    # iterate through files
    foreach my $file (@files) {
        open ($IN, "<$file") || die "Failed to open $file: $! $?\n";
        my $ct = 1;
            # iterate through rels file
            while (<$IN>) {
                chop;
                if (/\r$/) {
                  s/\r//;
                  $eol = "\r\n";
                }
                my ($id, $effectiveTime, $active, $moduleId, $sourceId, $destinationId,
                    $relationshipGroup, $typeId, $characteristicTypeId, $modifierId) = split /\t/;

                # skip inactive or non-isa rels
                next unless $typeId eq $isaRel;
                next unless $active;
                $ct++;

                # push new child for parent
                push @{$parChd{$destinationId}}, $sourceId;
                $codes{$sourceId} = 1;
                $codes{$destinationId} = 1;
            }
            print "      $ct relationships loaded\n";
            close($IN);
    }

    # Load appropriate history relationships
    if ($history) {

        $ct = 0;
        our %qual = ();
        if ($history eq "min") {
            $qual{"900000000000527005"} = 1;
        } elsif ($history eq "mod") {
            $qual{"900000000000527005"} = 1;
            $qual{"900000000000526001"} = 1;
            $qual{"900000000000528000"} = 1;
            $qual{"1186924009"} = 1;
        }
        open ($IN, "<$historyFile") || die "Failed to open $historyFile: $! $?\n";
        my $ct = 0;
        # iterate through history file
        while (<$IN>) {
            chop; s/\r//;

            my ($id, $effectiveTime, $active, $moduleId, $refsetId,
                $referencedComponentId, $targetComponentId) = split /\t/;

            # skip unless the refsetId represents a qualifying historical association
            next unless $history eq "max" || $qual{$refsetId};
            # skip inactive
            next unless $active;
            # skip if the targetComponentId isn't one of the codes (to avoid moved_to/from stuff)
            next unless $codes{$targetComponentId};

            $ct++;

            # push new child (inactive concept) for parent (active concept)
            push @{$parChd{$targetComponentId}}, $referencedComponentId;
            $codes{$referencedComponentId} = 1;
        }
        print "      $ct historical relationships loaded\n";
        close($IN);
    }
}

#
# Get descendants of a root
# Input: root id
# Output: array of descendant ids
#
sub getDescendants {
    my($par, $depth) = @_;

    # if we've seen this node already, children are accounted for - bail
    if ($seen{$par}) { return (); }
    $seen{$par} = 1;

    # Add an entry for this concept
    my %descendants = ();
    $descendants{$par} = $depth;

    # Get Children of this node
    my @chd = @{$parChd{$par}};

    # If this is a leaf node, bail
    return %descendants if scalar(@chd) == 0;

    # Iterate through children, mark as descendant and recursively call
    foreach my $chd (@chd) {
        my %chddesc = getDescendants($chd, $depth+1);
        # merge child descendants with the current descendants list.
        foreach my $desc ( keys %chddesc) {
            $descendants{"$desc"} = $chddesc{$desc};
        }
    }

    return %descendants;
}