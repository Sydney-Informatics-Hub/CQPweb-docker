##############################################################################
# Dockerfile for the mysql/mariadb for CQPWeb
#
# Adds the mysql user to the www-data (apache) group so that it can 
# share the cache directory with the 

FROM mariadb

ARG APACHE_RUN_GROUP=${APACHE_RUN_GROUP}
ARG MYSQL_USER=${MYSQL_USER}

# make sure that the mysql daemon can write to www-data

RUN usermod -aG ${APACHE_RUN_GROUP} mysql

# make sure that the default db user can ingest files for the query cache

RUN echo "GRANT FILE ON *.* TO '${MYSQL_USER}'@'%'" > /docker-entrypoint-initdb.d/grant_file_privilege.sql