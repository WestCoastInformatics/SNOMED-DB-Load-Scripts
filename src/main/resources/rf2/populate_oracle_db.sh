#!/bin/bash -f

#
# Database connection parameters
# Set if necessary
#export ORACLE_HOME=/app/oracle/product/12.1.0/dbhome_1
# Please edit these variables to reflect your environment
user=snomed
password=snomed
tns_name=ORCLCDB
export NLS_LANG=AMERICAN_AMERICA.UTF8

# Oracle Docker on Ubuntu does not allow removing the log file
# Do this step prior to starting Docker to execute populate scripts
# /bin/rm -f oracle.log
# touch oracle.log
ef=0

echo "See oracle.log for detailed output"
echo "----------------------------------------" | tee -a oracle.log
echo "Starting ... `/bin/date`" | tee -a oracle.log
echo "----------------------------------------" | tee -a oracle.log
echo "ORACLE_HOME = $ORACLE_HOME" | tee -a oracle.log
echo "user =        $user" | tee -a oracle.log
echo "tns_name =    $tns_name" | tee -a oracle.log


DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "    Compute transitive closure relationship file ... `/bin/date`" | tee -a oracle.log
relFile=$DIR/Snapshot/Terminology/*_Relationship_Snapshot_*.txt
$DIR/compute_transitive_closure.pl --force --noself $relFile >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

echo "    Create tables ... `/bin/date`" | tee -a oracle.log
echo "@oracle_tables.sql" |  $ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

## Load TC table
if [ $ef -ne 1 ]; then
echo "    Load transitive closure table ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="transitiveclosure.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat concept.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" | tee -a oracle.log
echo "@oracle_view.sql"|$ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

## Load RF2 tables
if [ $ef -ne 1 ]; then
echo "    Load concept table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="concept.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat concept.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load description table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="description.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat description.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load identifier table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="identifier.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat identifier.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load relationship table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="relationship.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat relationship.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load relationship concrete values table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="relationshipconcretevalues.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat relationshipconcretevalues.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load owl expression table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="owlexpression.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat owlexpression.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load stated relationship table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="statedrelationship.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat statedrelationship.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load text definition table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="textdefinition.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat textdefinition.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load association table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="association.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat association.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load attribute value table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="attributevalue.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat attributevalue.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load simple refset table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="simple.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat simple.log >> oracle.log
fi

# No more complex maps
# if [ $ef -ne 1 ]; then
# echo "    Load complex map table data ... `/bin/date`" >> oracle.log 2>&1
# $ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="complexmap.ctl" >> oracle.log 2>&1
# if [ $? -ne 0 ]; then ef=1; fi
# cat complexmap.log >> oracle.log
# fi

if [ $ef -ne 1 ]; then
echo "    Load extended map table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="extendedmap.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat extendedmap.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load simple map table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="simplemap.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat simplemap.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load language table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="language.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat language.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load refset descriptor table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="refsetdescriptor.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat refsetdescriptor.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load description type table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="descriptiontype.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat descriptiontype.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Load module dependency table data ... `/bin/date`" | tee -a oracle.log
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="moduledependency.ctl" >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat moduledependency.log >> oracle.log
fi

if [ $ef -ne 1 ]; then
echo "    Create indexes ... `/bin/date`" | tee -a oracle.log
echo "@oracle_indexes.sql"|$ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" | tee -a oracle.log
echo "@oracle_views.sql"|$ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> oracle.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" | tee -a oracle.log
if [ $ef -eq 1 ]
then
  echo "There were one or more errors." | tee -a oracle.log
  retval=-1
else
  echo "Completed without errors." | tee -a oracle.log
  retval=0
fi
echo "Finished ... `/bin/date`" | tee -a oracle.log
echo "----------------------------------------" | tee -a oracle.log
exit $retval
