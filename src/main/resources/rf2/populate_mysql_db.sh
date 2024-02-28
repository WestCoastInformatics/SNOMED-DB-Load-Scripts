#!/bin/bash -f
#
# Database connection parameters
# Please edit these variables to reflect your environment
host=[update with your host]
user=root
password=admin
db_name=snomed

/bin/rm -f mysql.log
touch mysql.log
ef=0

echo "See mysql.log for detailed output"

echo "----------------------------------------" | tee -a mysql.log
echo "Starting ... `/bin/date`" | tee -a mysql.log
echo "----------------------------------------" | tee -a mysql.log
echo "user =       $user" | tee -a mysql.log
echo "db_name =    $db_name" | tee -a mysql.log
echo "host =       $host" | tee -a mysql.log

if [ "${password}" != "" ]; then
  password="-p${password}"
fi
if [ "${host}" != "" ]; then
  host="-h ${host}"
fi

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "    Compute transitive closure relationship file ... `/bin/date`" | tee -a mysql.log
relFile=$(find $DIR/Snapshot/Terminology/ -name "*_Relationship_Snapshot_*.txt" -print -quit)
#check if system has python or perl, run the corresponding script
if command -v python &> /dev/null
then
  echo "python found, running python script" >> mysql.log 2>&1
  python $DIR/compute_transitive_closure.py --force --noself $relFile >> mysql.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
elif command -v perl &> /dev/null
then
  echo "perl found, running perl script" >> mysql.log 2>&1
  perl $DIR/compute_transitive_closure.pl --force --noself $relFile >> mysql.log 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
# if none are present, print error message
else
  echo "No python or perl found. Please install one of them." | tee -a mysql.log
  ef=1
fi

echo "    Create and load tables ... `/bin/date`" | tee -a mysql.log
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_tables.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

if [ $ef -ne 1 ]; then
echo "    Create indexes ... `/bin/date`" | tee -a mysql.log
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_indexes.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" | tee -a mysql.log
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_views.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" | tee -a mysql.log
if [ $ef -eq 1 ]
then
  echo "There were one or more errors." | tee -a mysql.log
  retval=-1
else
  echo "Completed without errors." | tee - a mysql.log
  retval=0
fi
echo "Finished ... `/bin/date`" | tee -a mysql.log
echo "----------------------------------------" | tee -a mysql.log
exit $retval
