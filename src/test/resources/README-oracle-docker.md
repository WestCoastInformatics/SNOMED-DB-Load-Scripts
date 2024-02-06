# Oracle 12c
## Prerequisites
1. Log into DockerHub and agree to Oracle's Terms of Service
   - https://hub.docker.com/_/oracle-database-enterprise-edition?tab=description (Click "Proceed to checkout")

2. For testing oracle, run a docker oracle instance
   - https://dzone.com/articles/oracle-12c-image-installation-in-docker

3. If you're running this locally, you will use `localhost` as the host. If you're running this on a remote server,
  you will use the server's IP address as the host.

4. If running an Oracle Database Docker Container on Linux use docker login and enter your hub.docker.com
 credentials for image to download.


## File Setup WINDOWS

1. Download the SNOMED distribution from NLM
   1. Unpack to `c:/data/SnomedCT_International` (for international edition)
   2. Unpack to `c:/data/SnomedCT_US` (for US edition)
2. Clone and build the project
    1. `git@github.com:WestCoastInformatics/SNOMED-DB-Load-Scripts.git`
3. Open the `target/snomed-db-scripts-oracle.zip` file
4. Copy the contents of the `rf2` directory to the folder where SNOMED data is unpacked (see above)

## File Setup LINUX (BUILD SERVER)
```
cd /wci/data
unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-oracle.*.zip
sudo chmod +x rf2/populate_oracle_db.sh
```

## Launch the container WINDOWS
```
dir=C:/data
cd %dir%
docker run --name snomed-oracle -v %dir%:/data -d --rm -p 8080:8080 -p 1521:1521 store/oracle/database-enterprise:12.2.0.1-slim
```

## If not running Docker as root LINUX (BUILD SERVER)
```
cd $dir/rf2
touch oracle.log concept.log description.log identifier.log relationship.log owlexpression.log statedrelationship.log textdefinition.log association.log attributevalue.log simple.log complexmap.log extendedmap.log simplemap.log language.log refsetdescriptor.log descriptiontype.log moduledependency.log relationshipconcretevalues.log
chmod a=rw oracle.log concept.log description.log identifier.log relationship.log owlexpression.log statedrelationship.log textdefinition.log association.log attributevalue.log simple.log complexmap.log extendedmap.log simplemap.log language.log refsetdescriptor.log descriptiontype.log moduledependency.log relationshipconcretevalues.log
```

## Create log files and allow read/write to all users.
1. Launch the container LINUX (BUILD SERVER)
```
export dir=/wci/data/
cd $dir

#For store/oracle/database-enterprise:12.2.0.1-slim
sudo docker run --name snomed-oracle -v $dir:/data -d --rm -p 8080:8080 -p 1521:1521 store/oracle/database-enterprise:12.2.0.1-slim

#For container-registry.oracle.com/database/enterprise:12.1.0.2
sudo docker run --name snomed-oracle -v $dir:/data -d --rm -p 8080:8080 -p 1521:1521  container-registry.oracle.com/database/enterprise:12.1.0.2
```

## Populate DB

1. Launch the container

`sudo docker exec -it snomed-oracle /bin/bash`
2. Populate the database
```
root@842bfb3da1f1:/# . /home/oracle/.bashrc
root@842bfb3da1f1:/# sqlplus sys/Oradoc_db1 as sysdba
alter session set "_ORACLE_SCRIPT"=true;
create user snomed identified by snomed;
GRANT CONNECT, RESOURCE, DBA TO snomed;
exit

root@842bfb3da1f1:/# cd /data/rf2
root@842bfb3da1f1:/data/rf2# ./populate_oracle_db.sh
```

## Connect to Oracle database to query tables
1. Skip docker exec command if still connected from prior step

```
sudo docker exec -it snomed-oracle /bin/bash
root@842bfb3da1f1:/# . /home/oracle/.bashrc
root@842bfb3da1f1:/# sqlplus snomed/snomed@ORCLCDB
```

