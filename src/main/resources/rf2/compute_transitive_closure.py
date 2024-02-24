import sys
import os
import csv
import glob
import argparse


isaRel = "116680003"
root = "138875005"
history = ""

## Function to parse arguments
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--force', action='store_true')
    parser.add_argument('--noself', action='store_true')
    parser.add_argument('relsFilePattern')
    return parser.parse_args()

args = parse_args()
force = args.force
self = not args.noself
relsFilePattern = args.relsFilePattern
relsFiles = glob.glob(relsFilePattern)

codes = {}
parChd = {}
seen = {}

## Function to initialize relationships
def initRelationships(relsFile, historyFile):
    global codes, parChd
    # Read relationships
    with open(relsFile, 'r') as f:
        reader = csv.reader(f, delimiter='\t')
        for row in reader:
            id, effectiveTime, active, moduleId, sourceId, destinationId, relationshipGroup, typeId, characteristicTypeId, modifierId = row
            if typeId != isaRel or not active:
                continue
            if destinationId not in parChd:
                parChd[destinationId] = []
            parChd[destinationId].append(sourceId)
            codes[sourceId] = 1
            codes[destinationId] = 1

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

## Main function
def main():
    global outputFile
    # Check if output file already exists
    for relsFile in relsFiles:
            outputFile = relsFile.replace("_Relationship_", "_TransitiveClosure_")
            # If output file already exists, remove it if force is set
            if os.path.exists(outputFile):
                if force:
                    os.remove(outputFile)
                else:
                    print(f"Output file already exists: {outputFile}")
                    sys.exit(1)

    # Initialize relationships
    initRelationships(relsFile, "")

    # Write transitive closure to output file
    with open(outputFile, 'w') as f:
        writer = csv.writer(f, delimiter='\t')
        writer.writerow(["superTypeId", "subTypeId", "depth"])
        for code in codes.keys():
            if code == root:
                continue
            if code not in parChd and self:
                writer.writerow([code, code, 0])
            else:
                descendants = getDescendants(code, 1)
                for desc, depth in descendants.items():
                    if not self and not (depth-1):
                        continue
                    writer.writerow([code, desc, depth-1])

## Run main function
if __name__ == "__main__":
    main()