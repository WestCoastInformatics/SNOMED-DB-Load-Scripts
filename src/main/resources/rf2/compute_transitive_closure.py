#!/usr/bin/python
# Copyright 2025 West Coast Informatics, Inc
#
# Computes transitive closure from a snapshot inferred RF2 relationships file.
#

import sys
import os
import csv
import glob
import argparse
import time
import logging
# Remove type hints for Python 2.7 compatibility

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

# Set up logging
logging.basicConfig(level=logging.DEBUG)

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
    parser.add_argument('--history-min', action='store_const', const='min', dest='history')
    parser.add_argument('--history-mod', action='store_const', const='mod', dest='history')
    parser.add_argument('--history-max', action='store_const', const='max', dest='history')
    parser.add_argument('--force', action='store_true')
    parser.add_argument('--noself', action='store_true')
    parser.add_argument('relsFile', help='RF2 relationships file')
    parser.add_argument('--help', action=HelpAction)

    args = parser.parse_args()
    return args

## Function to initialize relationships
def initRelationships(relsFile, historyFile):
    global codes, parChd
    try:
        # Read relationships
        with open(relsFile, 'r') as f:
            reader = csv.reader(f, delimiter='\t')
            next(reader)  # Skip header row
            ct = 1
            # iterate through rels file
            for row in reader:
                if len(row) < 10:  # Add validation
                    continue
                id, effectiveTime, active, moduleId, sourceId, destinationId, relationshipGroup, typeId, characteristicTypeId, modifierId = row
                # skip inactive or non-isa relationships
                if typeId != isaRel or active != '1':  # Check for '1' instead of boolean
                    continue
                ct += 1

                # push new child for parent
                if destinationId not in parChd:
                    parChd[destinationId] = []
                parChd[destinationId].append(sourceId)
                codes[sourceId] = 1
                codes[destinationId] = 1

        logging.info("      {} relationships loaded".format(ct))
    except IOError as e:
        logging.error("Failed to open {}: {}".format(relsFile, e))
        exit(1)

    # Load appropriate history relationships
    if history:
        try:
            ct = 0
            qual = {}
            if history == "min":
                qual = {"900000000000527005": 1}
            elif history == "mod":
                qual = {"900000000000527005": 1, "900000000000526001": 1,
                       "900000000000528000": 1, "1186924009": 1}

            with open(historyFile, 'r') as IN:
                reader = csv.reader(IN, delimiter='\t')
                next(reader)  # Skip header
                for row in reader:
                    id, effectiveTime, active, moduleId, refsetId, referencedComponentId, targetComponentId = row

                    # skip unless qualifying historical association
                    if not (history == "max" or refsetId in qual):
                        continue
                    # skip inactive
                    if active != '1':  # Check for string '1' instead of boolean
                        continue
                    # skip if targetComponentId not in codes
                    if targetComponentId not in codes:
                        continue

                    ct += 1

                    # push new child for parent
                    if targetComponentId not in parChd:
                        parChd[targetComponentId] = []
                    parChd[targetComponentId].append(referencedComponentId)
                    codes[referencedComponentId] = 1

            logging.info("      {} historical relationships loaded".format(ct))
        except Exception as e:
            logging.error("Error processing history file: {}".format(e))
            raise

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
    args = parse_args()
    global force, self, history
    force = args.force
    self = not args.noself
    history = args.history
    relsFile = args.relsFile
    outputFile = relsFile.replace("_Relationship_", "_TransitiveClosure_")

    # Check output file
    if os.path.exists(outputFile):
        if force:
            os.remove(outputFile)
        else:
            raise Exception("Output file already exists: {}. Check this is not an old file".format(outputFile))

    # Determine history file path
    historyFile = ""
    if history:
        historyFile = relsFile.replace("sct2_Relationship_", "der2_cRefset_Association")
        if historyFile.startswith("der2"):
            historyFile = os.path.join("..", "Refset", "Content", historyFile)
        elif "Terminology" in historyFile:
            historyFile = historyFile.replace("Terminology", "Refset/Content")
        else:
            raise Exception("Unable to determine path to Association refset file from relationships file = {}".format(relsFile))
        if not os.path.exists(historyFile):
            raise Exception("Computed path to Association refset file does not exist = {}".format(historyFile))

    # Print configuration
    print("------------------------------------------------------------")
    print("Starting ... {}".format(time.asctime()))
    print("------------------------------------------------------------")
    print("Isa rel      : {}".format(isaRel))
    print("Rels file    : {}".format(relsFile))
    print("Self         : {}".format(self))
    print("Output file  : {}".format(outputFile))
    if history:
        print("History      : {}".format(history))
        print("History file : {}".format(historyFile))
    print("\n")

    # Initialize relationships
    print("    Load PAR/CHD rels ... {}".format(time.asctime()))
    initRelationships(relsFile, historyFile)

    # Write transitive closure to output file
    print("    Write transitive closure table ... {}".format(time.asctime()))
    ct = 0  # Initialize counter here
    with open(outputFile, 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["superTypeId", "subTypeId", "depth"])
        for code in codes.keys():
            ct += 1  # Increment counter for each code
            # skip root
            if code == root:
                continue
            # short circuit for leaf nodes
            if code not in parChd and self:
                writer.writerow([code, code, 0])
            # gather descendants
            else:
                seen.clear()  # Clear seen dict for each new code
                descendants = getDescendants(code, 1)
                for desc, depth in descendants.items():
                    if not self and not (depth-1):
                        continue
                    writer.writerow([code, desc, depth-1])

            if ct % 10000 == 0:
                logging.info("      {} codes processed ... {}".format(ct, time.asctime()))

    print("------------------------------------------------------------")
    print("finished ... {}".format(time.asctime()))
    print("------------------------------------------------------------\n")


## Run main function
if __name__ == "__main__":
    main()