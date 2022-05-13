##############################################################################
# Dockerfile for CQPweb
#
# Use a single-stage build:
#  - based on rocket-org R-base docker
#  - download and build cwb
#  - install CQPweb dependencies incl. cwb
##############################################################################


##############################################################################
###
FROM r-base:latest
LABEL maintainer="Luigi <luigi@rahona.be>"
ENV LANG C.UTF-8
ARG CWB_REVISION=HEAD
ARG REGISTRY_VOL
ARG WEB_ROOT
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG CQPWEB_ADMIN
ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP
ARG APACHE_LOG_DIR
ARG APACHE_PID_FILE
ARG APACHE_RUN_DIR
ARG APACHE_LOCK_DIR

# Set APT::Get::Assume-Yes
RUN echo 'APT { GET { Assume-Yes "true"; }; };' >> /etc/apt/apt.conf
RUN echo 'APT { GET { Fix-Broken "true"; }; };' >> /etc/apt/apt.conf

# Install system utils
RUN apt-get update \
    && apt-get install \
        subversion

# Get source
WORKDIR /usr/local/src
ADD http://svn.code.sf.net/p/cwb/code/cwb/trunk cwb.revision
#Cwb
RUN svn co -r ${CWB_REVISION} http://svn.code.sf.net/p/cwb/code/cwb/trunk/ cwb
RUN grep -E '^VERSION = ' cwb/definitions.mk | cut -c11- > cwb.version

# Install generic dependencies for web app
# 1) the ones that come with apt-get
RUN apt-get update \
    && apt-get install \
        apache2 \
        libapache2-mod-php \
        php-xml \
	php-mysql \
	php-mbstring \
	php-json \
	php-gd \
	less \
	mysql-client


# Get source
WORKDIR /usr/local/src
ADD https://sourceforge.net/projects/cwb/files/cwb/cwb-3.5-RC/cwb-3.4.33-src.tar.gz/download cwb.tar.gz
RUN tar -xzvf cwb.tar.gz
# cwb -> cwb-3.x.x
RUN ln -s cwb-* cwb
WORKDIR /usr/local/src/cwb
ENV PLATFORM=linux-64
ENV SITE=binary-release
RUN install-scripts/install-linux

#Cwb perl
WORKDIR /usr/local/src
RUN svn co http://svn.code.sf.net/p/cwb/code/perl/trunk/CWB CWB-perl

WORKDIR /usr/local/src/CWB-perl
RUN perl Makefile.PL \
    && make \
    && make test \
    && make install

#Install CQPweb
WORKDIR ${WEB_ROOT}
RUN svn co http://svn.code.sf.net/p/cwb/code/gui/cqpweb/branches/3.2-latest CQPweb

ENV MYSQL_DATABASE ${MYSQL_DATABASE}
ENV MYSQL_USER ${MYSQL_USER}
ENV MYSQL_PASSWORD ${MYSQL_PASSWORD}
ENV CQPWEB_ADMIN ${CQPWEB_ADMIN}
ENV APACHE_RUN_USER ${APACHE_RUN_USER}
ENV APACHE_RUN_GROUP ${APACHE_RUN_GROUP}
ENV APACHE_LOG_DIR ${APACHE_LOG_DIR}
ENV APACHE_PID_FILE ${APACHE_PID_FILE}
ENV APACHE_RUN_DIR ${APACHE_RUN_DIR}
ENV APACHE_LOCK_DIR ${APACHE_LOCK_DIR}
ENV REGISTRY_VOL ${REGISTRY_VOL}
ENV WEB_ROOT ${WEB_ROOT}
COPY configure.sh /usr/local/bin/

RUN bash /usr/local/bin/configure.sh

# helper to start apache2 in foreground
COPY start_apache.sh /usr/local/bin/

CMD ["start_apache.sh"]
