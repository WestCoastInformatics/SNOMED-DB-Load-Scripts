#!/bin/bash -f
#
# Database connection parameters
# Please edit these variables to reflect your environment
host=172.17.0.2
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
relFile=$DIR/Snapshot/Terminology/*_Relationship_Snapshot_*.txt
if [[ ! -e "$DIR/compute_transitive_closure.pl --force --noself $relFile" ]] >> mysql.log 2>&1; then
  echo "    TC file created successfully" | tee -a mysql.log
  else
    echo "    ERROR: failed to compute TC relationship file. See mysql.log for more details."
    exit 1
fi
if [ $? -ne 0 ]; then ef=1; fi


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
