#!/bin/bash -f

#
# Database connection parameters
# Please edit these variables to reflect your environment
export PGHOST=172.17.0.1
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
$DIR/compute_transitive_closure.pl --force --noself $relFile >> postgres.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

echo "    Create and load tables ... `/bin/date`" | tee -a postgres.log
psql < psql_tables.sql >> postgres.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

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
