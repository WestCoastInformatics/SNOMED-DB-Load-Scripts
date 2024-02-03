################################
###### LINUX INSTRUCTIONS ######
################################

##### File Setup LINUX (BUILD SERVER) #####

cd /wci/data
unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-mysql.*.zip
sudo chmod +x rf2/populate_mysql_db.sh


##### MySQL 5.7 #####
#
# For testing mysql, run a docker mysql instance
#  - https://hub.docker.com/_/mysql

#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mysql:5.7

# BUILD SERVER
# Make sure to edit the host setting before proceeding. To find the docker container's IP address, run the following command:
# docker inspect <container name or id> | grep "IPAddress"
export host=172.17.0.1
export dir=/wci/data/
cd $dir
docker run -it -v $dir:/data mysql:5.7 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh


##### MySQL 8.0 #####
#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mysql:8.0 --local_infile=ON

# BUILD SERVER
# Make sure to edit the host setting before proceeding. To find the docker container's IP address, run the following command:
# docker inspect <container name or id> | grep "IPAddress"
export host=172.17.0.1
export dir=/wci/data/
cd $dir
docker run -it -v $dir:/data mysql:8.0 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh


##### MariaDB - 10.11 #####
#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mariadb:10.11

# BUILD SERVER
# Make sure to edit the host setting before proceeding. To find the docker container's IP address, run the following command:
# docker inspect <container name or id> | grep "IPAddress"
export host=172.17.0.1
export dir=/wci/data/
cd $dir
docker run -it -v $dir:/data mariadb:10.11 /bin/bash

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh

==================================================================================================

################################
##### WINDOWS INSTRUCTIONS #####
################################

##### File Setup #####

* Download the SNOMED distribution from NLM
* Unpack to c:/data/SnomedCT_International (for international edition)
* Unpack to c:/data/SnomedCT_US (for US edition)
* Clone and build these projects
    * git@github.com:WestCoastInformatics/SNOMED-DB-Load-Scripts.git
    * git@github.com:WestCoastInformatics/SNOMED-CT-Transitive-Closure.git
* Open the target/snomed*-mysql*zip file
* Copy the contents of the "rf2" directory to folder where SNOMED data is unpacked (see above)


##### MySQL 5.7 #####
#
# For testing mysql, run a docker mysql instance
#  - https://hub.docker.com/_/mysql

#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mysql:5.7

# git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data mysql:5.7 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh


##### MySQL 8.0 #####
#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mysql:8.0 --local_infile=ON

# git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data mysql:8.0 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh


##### MariaDB - 10.11 #####
#
# Launch the container
#
docker run --name snomed-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=snomed -d --rm mariadb:10.11

# git bash (to simulate running in Linux)
# export PGHOST=host.docker.internal  (**make sure to edit this setting before proceeding)
dir=C:/data
docker run -it -v "$dir":/data mariadb:10.11 /bin/bash
root@842bfb3da1f1:/# cd /data/SnomedCT_International
root@842bfb3da1f1:/data/rf2# ./populate_mysql_db.sh



