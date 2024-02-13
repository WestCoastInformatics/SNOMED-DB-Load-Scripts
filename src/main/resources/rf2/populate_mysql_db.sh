#!/bin/bash -f
#
# Database connection parameters
# Please edit these variables to reflect your environment
host=[set host name]
user=root
password=admin
db_name=snomed

/bin/rm -f mysql.log
touch mysql.log
ef=0

echo "See mysql.log for output"

echo "----------------------------------------" >> mysql.log 2>&1
echo "Starting ... `/bin/date`" >> mysql.log 2>&1
echo "----------------------------------------" >> mysql.log 2>&1
echo "user =       $user" >> mysql.log 2>&1
echo "db_name =    $db_name" >> mysql.log 2>&1
echo "host =       $host" >> mysql.log 2>&1

if [ "${password}" != "" ]; then
  password="-p${password}"
fi
if [ "${host}" != "" ]; then
  host="-h ${host}"
fi

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "    Compute transitive closure relationship file ... `/bin/date`" >> mysql.log 2>&1
relFile=$DIR/Snapshot/Terminology/*_Relationship_Snapshot_*.txt
$DIR/compute_transitive_closure.pl --force --noself $relFile >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi


echo "    Create and load tables ... `/bin/date`" >> mysql.log 2>&1
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_tables.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi

if [ $ef -ne 1 ]; then
echo "    Create indexes ... `/bin/date`" >> mysql.log 2>&1
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_indexes.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
echo "    Create views ... `/bin/date`" >> mysql.log 2>&1
mysql -vvv $host -u $user $password --local-infile $db_name < mysql_views.sql >> mysql.log 2>&1
if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" >> mysql.log 2>&1
if [ $ef -eq 1 ]
then
  echo "There were one or more errors." >> mysql.log 2>&1
  retval=-1
else
  echo "Completed without errors." >> mysql.log 2>&1
  retval=0
fi
echo "Finished ... `/bin/date`" >> mysql.log 2>&1
echo "----------------------------------------" >> mysql.log 2>&1
exit $retval
