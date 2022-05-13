#!/bin/bash

set -e

for regfile in ${REGISTRY_VOL}/*; do
	target="${WEB_ROOT}/CQPweb/${regfile##*/}"
	if ! [[ $regfile =~ __freq$ || -e $target ]]
	then 
		echo "linking corpus ${target}"
		ln -s ${WEB_ROOT}/CQPweb/exe $target
	fi
done 


#/var/www/html, where CQPweb sits
chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/html
#/var/upload, where CQPweb upload file
chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/cqpweb/upload
chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/cqpweb/tmp

# Apache gets grumpy about PID files pre-existing
rm -f ${APACHE_PID_FILE}

exec apache2 -DFOREGROUND
