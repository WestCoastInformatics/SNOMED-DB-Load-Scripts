#!/bin/bash -f

#
# Database connection parameters
# Set if necessary
#export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
# PLEASE EDIT THESE VARIABLES TO REFLECT YOUR ENVIRONMENT
user=snomed
password=snomed
tns_name=ORCLCDB
export NLS_LANG=AMERICAN_AMERICA.UTF8

LOG_FILE=oracle.log

# Clear the log file. If it doesn't exist, create it.
> $LOG_FILE
ef=0

echo "See $LOG_FILE for detailed output"
echo "----------------------------------------" | tee -a $LOG_FILE
echo "Starting ... `/bin/date`" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE
echo "ORACLE_HOME = $ORACLE_HOME" | tee -a $LOG_FILE
echo "user =        $user" | tee -a $LOG_FILE
echo "tns_name =    $tns_name" | tee -a $LOG_FILE


DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "    Compute transitive closure relationship file ... `/bin/date`" | tee -a $LOG_FILE
relFile=$(find $DIR/Snapshot/Terminology/ -name "*_Relationship_Snapshot_*.txt" -print -quit)
#check if system has python or perl, run the corresponding script
if command -v perl &> /dev/null
then
  echo "perl found, running perl script" >> $LOG_FILE 2>&1
  perl $DIR/compute_transitive_closure.pl --force --noself $relFile >> $LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
elif command -v python &> /dev/null
then
  echo "python found, running python script" >> $LOG_FILE 2>&1
  python $DIR/compute_transitive_closure.py --force --noself $relFile >> $LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
# if none are present, print error message
else
  echo "No perl or python found on your machine. Please install one of them to proceed." | tee -a $LOG_FILE
  ef=1
fi

if [ $ef -ne 1 ]; then
echo "    Create tables ... `/bin/date`" | tee -a $LOG_FILE
echo "@oracle_tables.sql" |  $ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

## Load RF2 tables
if [ $ef -ne 1 ]; then
echo "    Load concept table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="concept.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat concept.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load description table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="description.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat description.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load identifier table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="identifier.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat identifier.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load relationship table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="relationship.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat relationship.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load relationship concrete values table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="relationshipconcretevalues.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat relationshipconcretevalues.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load owl expression table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="owlexpression.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat owlexpression.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load stated relationship table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="statedrelationship.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat statedrelationship.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load text definition table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="textdefinition.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat textdefinition.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load association table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="association.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat association.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load attribute value table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="attributevalue.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat attributevalue.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load simple refset table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="simple.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat simple.log >> $LOG_FILE
fi

## Load TC table
if [ $ef -ne 1 ]; then
echo "    Load transitive closure table ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="transitiveclosure.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat concept.log >> $LOG_FILE
fi

# No more complex maps
# if [ $ef -ne 1 ]; then
# echo "    Load complex map table data ... `/bin/date`" >> $LOG_FILE 2>&1
# $ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="complexmap.ctl" >> $LOG_FILE 2>&1
# if [ $? -ne 0 ]; then ef=1; fi
# cat complexmap.log >> $LOG_FILE
# fi

if [ $ef -ne 1 ]; then
echo "    Load extended map table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="extendedmap.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat extendedmap.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load simple map table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="simplemap.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat simplemap.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load language table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="language.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat language.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load refset descriptor table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="refsetdescriptor.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat refsetdescriptor.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load description type table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="descriptiontype.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat descriptiontype.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Load module dependency table data ... `/bin/date`" | tee -a $LOG_FILE
$ORACLE_HOME/bin/sqlldr $user/$password@$tns_name control="moduledependency.ctl" >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
cat moduledependency.log >> $LOG_FILE
fi

if [ $ef -ne 1 ]; then
echo "    Create indexes ... `/bin/date`" | tee -a $LOG_FILE
echo "@oracle_indexes.sql"|$ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" | tee -a $LOG_FILE
echo "@oracle_views.sql"|$ORACLE_HOME/bin/sqlplus $user/$password@$tns_name  >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" | tee -a $LOG_FILE
if [ $ef -eq 1 ]
then
  echo "There were one or more errors." | tee -a $LOG_FILE
  retval=-1
else
  echo "Completed without errors." | tee -a $LOG_FILE
  retval=0
fi
echo "Finished ... `/bin/date`" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE
exit $retval
