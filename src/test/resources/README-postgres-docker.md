# BUILD INSTRUCTIONS 
## Pre-requisites
Before proceeding, make sure you updated the PGHOST in the load script.

## File Setup
```
   cd /wci/data
   unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-postgres.*.zip
   sudo chmod +x rf2/populate_postgres_db.sh
   sudo chmod +x rf2/compute_transitive_closure.pl
```

* For testing postgres, run a docker postgres instance - https://hub.docker.com/_/postgres

### Postgres 12.15 
1. Launch the container </br>
`docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:12.15`


2. Build Server
```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:12.15 /bin/bash
   
   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 13.11 
1. Launch the container </br>
`docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:13.11`

2. Build Server
```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:13.11 /bin/bash
   
   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 14.8 
1. Launch the container </br>
`docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:14.8`


2. Build Server
```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:14.8 /bin/bash
   
   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 15.3 
1. Launch the container </br>
`docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:15.3`


2. Build Server
```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:15.3 /bin/bash
   
   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```