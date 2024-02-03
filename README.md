SNOMED CT DATABASE LOAD SCRIPTS
===============================
Scripts to create and populate a MySQL, Postgres, or Oracle database with a
SNOMED CT terminology release in RF2.

To download a package built for the latest US or International edition, visit
https://www.westcoastinformatics.com/products/db-load-scripts

SNOMED CT TRANSITIVE CLOSURE
============================
Code to build a transitive closure table from an RF2, snapshot,
inferred SNOMED CT relationships file.  Additionally includes scripts
to create and populate a Postgres, Oracle, or MySQL (and MariaDB) database
with this data.  To download a package built for the latest US or International
edition, visit:
http://www.westcoastinformatics.com/resources.html

*New feature: a "depth" flag is now computed as well where 0 means "self",
1 means "child", and >1 means "non-child descendant".  This enables asking
queries about "child of", "descendant of", and "descendant or self of".


Minimum Specification
---------------------
- MySQL v5.7.+, MySQL v8.+, MariaDB 10.+, MariaDB 11.+
  - MySQL v8 requires the server to run with "--local_infile=ON"
- Oracle v12.+
- Postgres v12.+, v13.+, v14.+, v15.+, v16.+

Prerequisites
-------------
If loading transitive closure table into a database, first load SNOMED in RF2
using the database load scripts you can also find at the URL above.  This is
important because it creates a view that allows for denormalization of preferred
concept names, thus making the transitive closure table more useful.

Installation
------------
* See [HOWTO.txt](src/main/resources/HOWTO.md) file to understand how to load the rf2 files into the database

See Also
--------
* [src/main/resources/LICENSE.txt](src/main/resources/LICENSE.txt)
* [src/main/resources/README.txt](src/main/resources/README.md)
* [src/main/resources/HOWTO.txt](src/main/resources/HOWTO.md)
* [src/main/perl/transitiveClosure.pl](src/main/assembly/perl/transitiveClosure.pl) - this is just a pure Perl script for generating transitive closure from a SNOMED relationships file.
```
$ ./transitiveClosure.pl
This script has the following usage:
transitiveClosure.pl <relsFile> <outputFile>
```

TODO
----
Next Steps:
* Better automated QA to validate file sizes against table sizes
* Better automated QA to validate views have same row count as driving tables

