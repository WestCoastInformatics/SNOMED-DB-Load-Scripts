
##### File Setup WINDOWS

* Download the SNOMED distribution from NLM
* Unpack to c:/data/SnomedCT_International (for international edition)
* Unpack to c:/data/SnomedCT_US (for US edition)
* Clone and build these projects
    * git@github.com:WestCoastInformatics/SNOMED-DB-Load-Scripts.git
    * git@github.com:WestCoastInformatics/SNOMED-CT-Transitive-Closure.git
* Open the target/snomed*-postgres*zip file
* Copy the contents of the "rf2" directory to folder where SNOMED data is unpacked (see above)
* Go to that directory and run transitive_closure.sh/bat to generate the transitive closure file

##### File Setup LINUX (BUILD SERVER)

cd /wci/data
unzip -o /wci/projects/SNOMED-CT-Transitive-Closure/target/snomed-transitive-closure-postgres.*.zip
unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-postgres.*.zip
sudo chmod +x rf2/populate_postgres_db.sh
sudo chmod +x rf2/populate_postgres_db_tc.sh

#
# For testing postgres, run a docker postgres instance
#  - https://hub.docker.com/_/postgres
#

##### Postgres 11.20
#
# Launch the container
#
docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:11.20-alpine

# WINDOWS git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data postgres:11.20 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

# LINUX (BUILD SERVER)
# export PGHOST=172.17.0.1  (**make sure to edit this setting before proceeding)
export dir=/wci/data/
cd $dir
docker run -it -v "$dir":/data postgres:11.20 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

##### Postgres 12.15
#
# Launch the container
#
docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:12.15

# WINDOWS git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data postgres:12.15 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

# LINUX (BUILD SERVER)
# export PGHOST=172.17.0.1  (**make sure to edit this setting before proceeding)
export dir=/wci/data/
cd $dir
docker run -it -v "$dir":/data postgres:12.15 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh


##### Postgres 13.11
#
# Launch the container
#
docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:13.11

# WINDOWS git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data postgres:13.11 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

# LINUX (BUILD SERVER)
# export PGHOST=172.17.0.1  (**make sure to edit this setting before proceeding)
export dir=/wci/data/
cd $dir
docker run -it -v "$dir":/data postgres:13.11 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh


##### Postgres 14.8
#
# Launch the container
#
docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:14.8

# WINDOWS git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data postgres:14.8 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

# LINUX (BUILD SERVER)
# export PGHOST=172.17.0.1  (**make sure to edit this setting before proceeding)
export dir=/wci/data/
cd $dir
docker run -it -v "$dir":/data postgres:14.8 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh



##### Postgres 15.3
#
# Launch the container
#
docker run --name snomed-postgres -p 5432:5432 -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=snomed -d --rm postgres:15.3

# WINDOWS git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data postgres:15.3 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh

# LINUX (BUILD SERVER)
# export PGHOST=172.17.0.1  (**make sure to edit this setting before proceeding)
export dir=/wci/data/
cd $dir
docker run -it -v "$dir":/data postgres:15.3 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db.sh
root@842bfb3da1f1:/data/rf2# ./populate_postgres_db_tc.sh
