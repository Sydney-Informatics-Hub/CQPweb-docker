##############################################################################
# Dockerfile for the mysql/mariadb for CQPWeb
#
# Adds the mysql user to the www-data (apache) group so that it can 
# share the cache directory with the 

FROM mariadb

ARG APACHE_RUN_GROUP=${APACHE_RUN_GROUP}

RUN echo ${APACHE_RUN_GROUP}

RUN usermod -aG ${APACHE_RUN_GROUP} mysql
