/*
 *    Copyright 2016 West Coast Informatics, LLC
 */
package com.wcinformatics.snomed;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Builder for a transitive closure table from SNOMED CT inferred relationships
 * file.
 *
 * @author bcarlsen@westcoastinformatics.com
 */
public class TransitiveClosureGenerator {

  /** The relationships file. */
  private String relationshipsFile;

  /** The output file. */
  private String outputFile;

  /** The is a rel. */
  private String isaRel = "116680003";

  /** The inferred char type. */
  private String inferredCharType = "900000000000011006";

  /** The root. */
  private String root = "138875005";

  /** The rf1 inactive concepts. */
  private String[] rf1InactiveConcepts = new String[] {
      "362955004", "363660007", "363661006", "363662004", "363663009",
      "363664003", "370126003", "443559000"
  };

  /**
   * Instantiates an empty {@link TransitiveClosureGenerator}.
   */
  public TransitiveClosureGenerator() {
    // do nothing
  }

  /**
   * Sets the relationships file.
   *
   * @param relationshipsFile the relationships file
   */
  public void setRelationshipsFile(String relationshipsFile) {
    this.relationshipsFile = relationshipsFile;
  }

  /**
   * Sets the output file.
   *
   * @param outputFile the output file
   */
  public void setOutputFile(String outputFile) {
    this.outputFile = outputFile;
  }

  /**
   * Sets the isa rel.
   *
   * @param isaRel the isa rel
   */
  public void setIsaRel(String isaRel) {
    this.isaRel = isaRel;
  }

  /**
   * Sets the root.
   *
   * @param root the root
   */
  public void setRoot(String root) {
    this.root = root;
  }

  /**
   * Sets the rf1 inactive concepts.
   *
   * @param rf1InactiveConcepts the rf1InactiveConcepts to set
   */
  public void setRf1InactiveConcepts(String[] rf1InactiveConcepts) {
    this.rf1InactiveConcepts = rf1InactiveConcepts;
  }

  /**
   * Compute the transitive closure file.
   *
   * @throws Exception the exception
   */
  public void compute() throws Exception {

    //
    // Check assumptions/prerequisites
    //
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "Start computing transitive closure ... " + new Date());

    if (relationshipsFile == null) {
      throw new Exception("Unexpected null relationships file.");
    }
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "  relationshipsFile = " + relationshipsFile);

    if (outputFile == null) {
      throw new Exception("Unexpected null output file.");
    }
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "  outputFile = " + outputFile);

    File rf = new File(relationshipsFile);
    if (!rf.exists()) {
      throw new Exception("relationships file does not exist.");
    }

    File of = new File(outputFile);
    if (of.exists()) {
      throw new Exception(
          "output file already exists. Please clean it up first.");
    }

    //
    // Initialize rels
    // id effectiveTime active moduleId sourceId destinationId relationshipGroup
    // typeId characteristicTypeId modifierId
    //
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "  Initialize relationships ... " + new Date());
    @SuppressWarnings("resource")
    PrintWriter out = new PrintWriter(new FileWriter(of));
    @SuppressWarnings("resource")
    BufferedReader in = new BufferedReader(new FileReader(rf));
    String line;
    Map<String, Set<String>> parChd = new HashMap<>();
    // skip header
    line = in.readLine();
    boolean rf1 = false;
    if (line.startsWith("RELATIONSHIPID")) {
      Logger.getLogger(this.getClass().getName()).log(Level.INFO,
          "    file format = RF1");
      rf1 = true;
    } else if (line.startsWith("id")) {
      Logger.getLogger(this.getClass().getName()).log(Level.INFO,
          "    file format = RF2");
    } else {
      throw new Exception("Unknown file format, not RF1 or RF2.");
    }
    int ct = 0;
    Set<String> all = new HashSet<>();
    while ((line = in.readLine()) != null) {
      String[] tokens = line.split("\t");

      String chd = null;
      String par = null;

      // Handle RF1
      if (rf1) {

        if (tokens.length != 7) {
          throw new Exception("Unexpected number of fields in rels file "
              + tokens.length);
        }
        // Skip non isa
        if (!isaRel.equals(tokens[2])) {
          continue;
        }
        // Skip inactive - n/a all RF1 rels are active

        // skip non inferred rels - n/a all RF1 rels are inferred

        // skip non defining relationships
        if (!tokens[4].equals("0")) {
          continue;
        }

        // skip children of "inactive concept" concept
        int i = Arrays.binarySearch(rf1InactiveConcepts, tokens[3]);
        if (i >= 0) {
          continue;
        }

        chd = tokens[1];
        par = tokens[3];
      }

      // Handle RF2
      else {

        if (tokens.length != 10) {
          throw new Exception("Unexpected number of fields in rels file "
              + tokens.length);
        }
        // Skip non isa
        if (!isaRel.equals(tokens[7])) {
          continue;
        }
        // Skip inactive
        if (!tokens[2].equals("1")) {
          continue;
        }
        // skip non inferred rels
        if (!inferredCharType.equals(tokens[8])) {
          throw new Exception("Unexpected non inferred relationship");
        }
        chd = tokens[4];
        par = tokens[5];
      }

      // Add par/chd relationship
      if (par == null || par.isEmpty()) {
        throw new Exception("Empty parent " + line);
      }
      if (chd == null || chd.isEmpty()) {
        throw new Exception("Empty child " + line);
      }
      // Add to "all"
      all.add(par);
      all.add(chd);
      
      // Handle par/chd
      if (!parChd.containsKey(par)) {
        parChd.put(par, new HashSet<String>());
      }
      Set<String> children = parChd.get(par);
      children.add(chd);

      ct++;
    }
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "      ct = " + ct);

    //
    // Write transitive closure file
    //
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "    Write transitive closure table ... " + new Date());
    // print header line
    out.print("superTypeId\tsubTypeId\tdepth\r\n");
    ct = 0;
    for (String code : all) {
      Logger.getLogger(this.getClass().getName()).log(Level.FINE,
          "      compute for " + code);

      if (root.equals(code)) {
        continue;
      }
      ct++;
      Map<String,Integer> descs = getDescendants(code, new HashSet<String>(), parChd, 0);
      for (Map.Entry<String,Integer> desc : descs.entrySet()) {
        Logger.getLogger(this.getClass().getName()).log(Level.FINEST,
            code + "\t" + desc.getKey() + "\t" + desc.getValue() + "\r\n");
        out.print(code + "\t" + desc.getKey() + "\t" + desc.getValue() + "\r\n");
        out.flush();
      }
      Logger.getLogger(this.getClass().getName()).log(Level.FINE,
          "      desc ct = " + descs.size());
      if (ct % 10000 == 0) {
        Logger.getLogger(this.getClass().getName()).log(Level.INFO,
            "      " + ct + " codes processed ..." + new Date());
      }
    }
    out.close();
    in.close();
    Logger.getLogger(this.getClass().getName()).log(Level.INFO,
        "Finished computing transitive closure ... " + new Date());
  }

  /**
   * Returns the descendants.
   *
   * @param par the par
   * @param seen the seen
   * @param parChd the par chd
   * @param depth the depth
   * @return the descendants
   */
  public Map<String, Integer> getDescendants(String par, Set<String> seen,
    Map<String, Set<String>> parChd, int depth) {
    // if we've seen this node already, children are accounted for - bail
    if (seen.contains(par)) {
      return new HashMap<>();
    }
    seen.add(par);

    // Add this entry
    Map<String, Integer> descendants = new HashMap<>();
    descendants.put(par, depth);

    // Get Children of this node
    Set<String> children = parChd.get(par);

    // If this is a leaf node, bail
    if (children == null || children.isEmpty()) {
      return descendants;
    }

    // Iterate through children, mark as descendant and recursively call
    for (String chd : children) {
      Map<String, Integer> descendantsOfChild =
          getDescendants(chd, seen, parChd, depth + 1);
      // add all recursively gathered descendants at this level
      descendants.putAll(descendantsOfChild);
    }

    return descendants;
  }

  /**
   * Application entry point. The first parameter should be the path to a
   * snapshot inferred RF2 relationships or RF1 relationships file. The second
   * parameter should be the output filename and should not yet exist.
   *
   * @param argv the command line arguments
   */
  public static void main(String[] argv) {
    try {
      TransitiveClosureGenerator generator = new TransitiveClosureGenerator();
      generator.setRelationshipsFile(argv[0]);
      generator.setOutputFile(argv[1]);
      generator.compute();
    } catch (Throwable t) {
      t.printStackTrace();
      System.exit(1);
    }
  }

}
