#!/usr/bin/python
# Copyright 2024 West Coast Informatics, Inc
#
# Computes transitive closure from a snapshot inferred RF2 relationships file.
#

import sys
import os
import csv
import glob
import argparse
import time

#
# Set Defaults & Environment
#
isaRel = "116680003"
root = "138875005"
history = ""
force = False
self = True
codes = {}
parChd = {}
seen = {}

# Define the errors dictionary globally
errors = {
    1: "Illegal switch: ",
    2: "Illegal service: ",
    3: "Bad number of arguments: ",
    4: "{} must be set"
}

## Custom help action for handling --help argparse option
class HelpAction(argparse.Action):
    def __init__(self, option_strings, dest, nargs=0, **kwargs):
        super(HelpAction, self).__init__(option_strings, dest, nargs=nargs, **kwargs)

    def __call__(self, parser, namespace, values, option_string=None):
        print_help()
        parser.exit()

## Function to parse arguments
def parse_args():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('--history', choices=['min', 'mod', 'max'])
    parser.add_argument('--force', action='store_true')
    parser.add_argument('--noself', action='store_true')
    parser.add_argument('relsFile')
    parser.add_argument('--help', action=HelpAction)  # Add the custom --help option

    try:
        args = parser.parse_args()
    except SystemExit:
        badargs = errors[3]
        print(badargs + args)
        exit(1)

   # Check if the arguments are valid
    if not args.relsFile:  # Check if relsFile is provided
        badargs = errors[4].format("relsFile")
    elif args.history and args.history not in ['min', 'mod', 'max']:  # Check if history is one of the allowed values
        badargs = errors[1] + args.history
    else:
        badargs = None

    # Check for argument errors
    if badargs:
        print_usage()
        print("\n{}".format(badargs))
        exit(1)

    return parser.parse_args()

## Function to initialize relationships
def initRelationships(relsFile, historyFile):
    global codes, parChd
    try:
        # Read relationships
        with open(relsFile, 'r') as f:
            reader = csv.reader(f, delimiter='\t')
            ct = 1
            # iterate through rels file
            for row in reader:
                id, effectiveTime, active, moduleId, sourceId, destinationId, relationshipGroup, typeId, characteristicTypeId, modifierId = row
                # skip inactive or non-isa relationships
                if typeId != isaRel or not active:
                    continue
                ct += 1

                # push new child for parent
                if destinationId not in parChd:
                    parChd[destinationId] = []
                parChd[destinationId].append(sourceId)
                codes[sourceId] = 1
                codes[destinationId] = 1
            pass
    except IOError as e:
        print(f"Failed to open {relsFile}: {e}")
        exit(1)

    # Load appropriate history relationships
    if history:
        ct = 0
        qual = {}
        if history == "min":
            qual = {"900000000000527005": 1}
        elif history == "mod":
            qual = {"900000000000527005": 1, "900000000000526001": 1, "900000000000528000": 1, "1186924009": 1}

        with open(historyFile, 'r') as IN:
            for line in IN:
                line = line.rstrip('\r\n')

                id, effectiveTime, active, moduleId, refsetId, referencedComponentId, targetComponentId = line.split('\t')

                # skip unless the refsetId represents a qualifying historical association
                if not (history == "max" or refsetId in qual):
                    continue
                # skip inactive
                if not active:
                    continue
                # skip if the targetComponentId isn't one of the codes (to avoid moved_to/from stuff)
                if targetComponentId not in codes:
                    continue

                ct += 1

                # push new child (inactive concept) for parent (active concept)
                if targetComponentId not in parChd:
                    parChd[targetComponentId] = []
                parChd[targetComponentId].append(referencedComponentId)
                codes[referencedComponentId] = 1

        print "      {} historical relationships loaded".format(ct)



## Function to get descendants
def getDescendants(par, depth):
    global seen
    # If parent has been seen, return empty dictionary
    if par in seen:
        return {}

    seen[par] = 1
    descendants = {par: depth}

    # If parent has children, get their descendants
    if par in parChd:
        for chd in parChd[par]:
            descendants.update(getDescendants(chd, depth+1))
    return descendants

## Function to print help
def print_help(parser=None, namespace=None, values=None, option_strings=None, dest=None):
    print_usage()

    help_text = """
    Parameters:
        relsFile: A snapshot inferred RF2 relationships file
    Options:
        --force: If output file already exists, remove it and proceed
        --history-{min,mod,max}: Add historical relationships to support ECL HISTORY-{MIN,MOD,MAX} profile
        --help: On-line help
    """
    print(help_text)
    sys.exit(0) # Exit the program

## Function to print usage
def print_usage():
    print("""
Usage: compute_transitive_closure.py [--help] [--force] [--history-{min,mod,max}] <relsFile>
  e.g. compute_transitive_closure.py --history-min --noself
""")

## Main function
def main():
    global badargs, ct
    args = parse_args()
    force = args.force
    self = not args.noself
    relsFile = args.relsFile
    history = args.history
    outputFile = relsFile.replace("_Relationship_", "_TransitiveClosure_")
    # initialize ct
    ct = 0

    # Check history file
    historyFile = ""
    if history:
        # Attempt to find the Association refset
        historyFile = relsFile.replace("sct2_Relationship_", "der2_cRefset_Association")
        if historyFile.startswith("der2"):
            historyFile = "../Refset/Content/" + historyFile
        elif "Terminology" in historyFile:
            historyFile = historyFile.replace("Terminology", "Refset/Content")
        else:
            raise Exception(f"Unable to determine path to Association refset file from relationships file = {relsFile}")
        if not os.path.exists(historyFile):
            raise Exception(f"Computed path to Association refset file does not exist =  {historyFile}")

    # Check if output file already exists
    if os.path.exists(outputFile):
        if force:
            os.remove(outputFile)
        else:
            print(f"Output file already exists: {outputFile}")
            exit(1)

    # Start processing
    print("------------------------------------------------------------")
    print("Starting ...", time.asctime())
    print("------------------------------------------------------------")
    print("Isa rel      : ", isaRel)
    print("Rels file    : ", relsFile)
    print("Self         : ", self)
    print("Output file  : ", outputFile)
    if history:
        print("History      : ", history)
        print("History file : ", historyFile)
    print("\n")

    # Load PAR/CHD relationships map
    print("    Load PAR/CHD rels ...", time.asctime())
    global codes, parChd, seen
    codes = {}
    parChd = {}
    seen = {}
    # Initialize relationships
    initRelationships(relsFile, "")

    # Write transitive closure to output file
    print("    Write transitive closure table ...", time.asctime())
    with open(outputFile, 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["superTypeId", "subTypeId", "depth"])
        for code in codes.keys():
            # skip root
            if code == root:
                ct += 1
                continue
            # short circuit for leaf nodes
            if code not in parChd and self:
                writer.writerow([code, code, 0])
            # gather descendants
            else:
                descendants = getDescendants(code, 1)
                for desc, depth in descendants.items():
                    if not self and not (depth-1):
                        continue
                    writer.writerow([code, desc, depth-1])

        if ct % 10000 == 0:
            print "      {} codes processed ...".format(ct), time.asctime()

    print("------------------------------------------------------------")
    print("finished ...", time.asctime())
    print("------------------------------------------------------------\n")


## Run main function
if __name__ == "__main__":
    main()