#!/bin/bash -f

#
# Database connection parameters
# PLEASE EDIT THESE VARIABLES TO REFLECT YOUR ENVIRONMENT
export PGHOST=[UPDATE]
export PGUSER=postgres
export PGPASSWORD=
export PGDATABASE=snomed

/bin/rm -f postgres.log
touch postgres.log
ef=0

echo "See postgres.log for output"

echo "----------------------------------------" | tee -a postgres.log
echo "Starting ... `/bin/date`" | tee -a postgres.log
echo "----------------------------------------" | tee -a postgres.log
echo "user =       $PGUSER" | tee -a postgres.log
echo "db_name =    $PGDATABASE" | tee -a postgres.log

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "    Compute transitive closure relationship file ... `/bin/date`" | tee -a postgres.log
relFile=$(find $DIR/Snapshot/Terminology/ -name "*_Relationship_Snapshot_*.txt" -print -quit)
#check if system has perl first, then python, run the corresponding script
if command -v perl &> /dev/null
then
  echo "perl found, running perl script" >> postgres.log 2>&1
  perl $DIR/compute_transitive_closure.pl --force --noself $relFile >> postgres.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
elif command -v python &> /dev/null
then
  echo "python found, running python script" >> postgres.log 2>&1
  python $DIR/compute_transitive_closure.py --force --noself $relFile >> postgres.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
# if none are present, print error message
else
  echo "No perl or python found on your machine. Please install one of them to proceed." | tee -a postgres.log
  ef=1
fi

if [ $ef -ne 1 ]; then
echo "    Create and load tables ... `/bin/date`" | tee -a postgres.log
psql < psql_tables.sql >> postgres.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create indexes ... `/bin/date`" | tee -a postgres.log
psql < psql_indexes.sql >> postgres.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" | tee -a postgres.log
psql < psql_views.sql >> postgres.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" | tee -a postgres.log
if [ $ef -eq 1 ]
then
  echo "There were one or more errors." | tee -a postgres.log
  retval=-1
else
  echo "Completed without errors." | tee -a postgres.log
  retval=0
fi
echo "Finished ... `/bin/date`" | tee -a postgres.log
echo "----------------------------------------" | tee -a postgres.log
exit $retval
