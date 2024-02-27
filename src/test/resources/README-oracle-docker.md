# Oracle 12c BUILD INSTRUCTIONS
## Prerequisites
1. Log into DockerHub and agree to Oracle's Terms of Service
   - [Oracle DB Enterprise Repository](https://container-registry.oracle.com/ords/f?p=113:1:103153009327673::::FSP_LANGUAGE_PREFERENCE:&cs=3vvrLolDIFGAxz-ReKVoNrPBwhCCJtGRffMagNzTnvafG3AeKT2KLWKQSclqKpS-c6TF2uprvjENxXOETZOmgfQ)
     - Log in with your account and then click on "Continue" on the line enterprise. This will allow you to pull the Oracle Database Enterprise Edition image from the Oracle Container Registry.
   - Pull the image from the Oracle Container Registry
     - `docker login container-registry.oracle.com` and enter your hub.docker.com credentials
     - `docker pull container-registry.oracle.com/database/enterprise:12.2.0.1-slim`
     - `docker pull container-registry.oracle.com/database/enterprise:12.1.0.2`
2. For testing oracle, run a docker oracle instance
   - https://dzone.com/articles/oracle-12c-image-installation-in-docker

3. If you're running this locally, you will use `localhost` as the host. If you're running this on a remote server,
  you will use the server's IP address as the host.

4. If running an Oracle Database Docker Container on Linux use docker login and enter your hub.docker.com
 credentials for image to download.

# Linux Instructions

## File Setup
```
    cd /wci/data
    unzip -o /wci/projects/SNOMED-DB-Load-Scripts/target/snomed-db-scripts-oracle.*.zip
    sudo chmod +x rf2/populate_oracle_db.sh
    sudo chmod +x rf2/compute_transitive_closure.pl

```

## If not running Docker as root
```
    cd $dir/rf2
    touch oracle.log concept.log description.log identifier.log relationship.log owlexpression.log statedrelationship.log textdefinition.log association.log attributevalue.log simple.log complexmap.log extendedmap.log simplemap.log language.log refsetdescriptor.log descriptiontype.log moduledependency.log relationshipconcretevalues.log
    chmod a=rw oracle.log concept.log description.log identifier.log relationship.log owlexpression.log statedrelationship.log textdefinition.log association.log attributevalue.log simple.log complexmap.log extendedmap.log simplemap.log language.log refsetdescriptor.log descriptiontype.log moduledependency.log relationshipconcretevalues.log
```

## Launch the container
Create log files and allow read/write to all users.
```
    export dir=/wci/data/
    cd $dir
    
    #For store/oracle/database-enterprise:12.2.0.1-slim
    sudo docker run --name snomed-oracle -v $dir:/data -d --rm -p 8080:8080 -p 1521:1521 container-registry.oracle.com/database/enterprise:12.2.0.1-slim
    
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
