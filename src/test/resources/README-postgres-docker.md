# BUILD INSTRUCTIONS

## Pre-requisites

Before proceeding, make sure you updated the PGHOST in the load script.

Check current versions: https://www.postgresql.org/support/versioning/
Add new versions, remove versions whose final release is the past and, bump the minor version numbers.

## File Setup

```
   cd /wci/data
   unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-postgres.*.zip
   sudo chmod +x rf2/populate_postgres_db.sh
   sudo chmod +x rf2/compute_transitive_closure.pl
```

- For testing postgres, run a docker postgres instance - https://hub.docker.com/_/postgres

### Postgres 13.20

1. Launch the container </br>
   `docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:13.20`

2. Build Server

```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:13.20 /bin/bash

   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 14.17

1. Launch the container </br>
   `docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:14.17`

2. Build Server

```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:14.17 /bin/bash

   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 15.12

1. Launch the container </br>
   `docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:15.12`

2. Build Server

```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:15.12 /bin/bash

   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 16.8

1. Launch the container </br>
   `docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:16.8`

2. Build Server

```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:16.8 /bin/bash

   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```

### Postgres 17.4

1. Launch the container </br>
   `docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:17.4`

2. Build Server

```
   export dir=/wci/data/
   cd $dir
   docker run -it -v "$dir":/data postgres:17.4 /bin/bash

   root@842bfb3da1f1:/# cd /data/rf2
   root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
```
