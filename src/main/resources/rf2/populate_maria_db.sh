#!/bin/bash -f
#
# Database connection parameters
# PLEASE EDIT THESE VARIABLES TO REFLECT YOUR ENVIRONMENT
host=[UPDATE]
user=root
password=admin
db_name=snomed

LOG_FILE=maria_db.log

/bin/rm -f $LOG_FILE
touch $LOG_FILE
ef=0

echo "See $LOG_FILE for detailed output"

echo "----------------------------------------" | tee -a $LOG_FILE
echo "Starting ... $(/bin/date)" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE
echo "user =       $user" | tee -a $LOG_FILE
echo "db_name =    $db_name" | tee -a $LOG_FILE
echo "host =       $host" | tee -a $LOG_FILE

if [ "${password}" != "" ]; then
  password="-p${password}"
fi
if [ "${host}" != "" ]; then
  host="-h ${host}"
fi

DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "    Compute transitive closure relationship file ... $(/bin/date)" | tee -a $LOG_FILE
relFile=$(find $DIR/Snapshot/Terminology/ -name "*_Relationship_Snapshot_*.txt" -print -quit)
#check if system has python or perl, run the corresponding script
if command -v perl &>/dev/null; then
  echo "perl found, running perl script" >>$LOG_FILE 2>&1
  perl $DIR/compute_transitive_closure.pl --force --noself $relFile >>$LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
elif command -v python &>/dev/null; then
  echo "python found, running python script" >>$LOG_FILE 2>&1
  python $DIR/compute_transitive_closure.py --force --noself $relFile >>$LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
# if none are present, print error message
else
  echo "No perl or python found on your machine. Please install one of them to proceed." | tee -a $LOG_FILE
  ef=1
fi

if [ $ef -ne 1 ]; then
  echo "    Create and load tables ... $(/bin/date)" | tee -a $LOG_FILE
  mariadb -vvv $host -u $user $password --local-infile $db_name <mysql_tables.sql >>$LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
  echo "    Create indexes ... $(/bin/date)" | tee -a $LOG_FILE
  mariadb -vvv $host -u $user $password --local-infile $db_name <mysql_indexes.sql >>$LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
fi

if [ $ef -ne 1 ]; then
  echo "    Create views ... $(/bin/date)" | tee -a $LOG_FILE
  mariadb -vvv $host -u $user $password --local-infile $db_name <mysql_views.sql >>$LOG_FILE 2>&1
  if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" | tee -a $LOG_FILE
if [ $ef -eq 1 ]; then
  echo "There were one or more errors." | tee -a $LOG_FILE
  retval=-1
else
  echo "Completed without errors." | tee - a $LOG_FILE
  retval=0
fi
echo "Finished ... $(/bin/date)" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE
exit $retval
