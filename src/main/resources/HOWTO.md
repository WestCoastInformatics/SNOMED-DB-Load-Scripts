# How To Use the SNOMED CT Database Loader
This HOWTO describes how to use the installer scripts to load SNOMED into a database.

## Installation
1.  Download the database loader zip file from the http://www.westcoastinformatics.com/resources.html website. Select the appropriate database-version pair (i.e. oracle-US Edition). Depending on your database and edition, identify the appropriate target's zip file.

2.  Unzip the contents of the zip file into a 'data' folder

3.  Download the SNOMED CT Release files in ZIP format. US Users can find the files here: 
	* [SNOMED CT® US Edition Release Files](https://www.nlm.nih.gov/healthit/snomedct/us_edition.html)
    * [SNOMED CT® International Edition Release Files](https://www.nlm.nih.gov/healthit/snomedct/international.html)

4.  Open the desired zip file and extract the 'Snapshot' folder into the 'data/rf2' folder. Once completed:
	* The 'data' folder's content will include:
		- 'rf2' folder
		- HOWTO.md
		- LICENSE.txt
		- README.md
	* The 'data/rf2' folder's contents will include:
		- 'Snapshot' folder
		- *.sql files
		- *.ctl files (for oracle only)
		- one *.sh file

5.	In a text editor, open the temp-folder's appropriate "populate" script as defined by your database. 
   * For example:
       - For MySQL (or MariaDB), use the "populate_mysql_db.sh" script
       - For Postgres, use the "populate_postgres_db.sh" script
       - For Oracle, use the "populate_oracle_db.sh" script
   * Configure settings at the top of the "populate" script for your environment
       - use your host's IP address or hostname
       - user is your database's username
       - password is your database's password
       - tns_name or db_name is the database's schema which is to be populated

6.  Create the database schema as defined in step #5

    * NOTE: postgres supports only db-level character encoding, so make sure to create your database using: `WITH ENCODING 'UTF-8'`


7.	Execute the "populate" script
	* Note: a complete log file will appear as `mysql.log`, `postgres.log`, or `oracle.log`
