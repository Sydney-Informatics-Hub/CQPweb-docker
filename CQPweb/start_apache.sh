#!/bin/bash

set -e

#write the CQPweb config

cat <<EOF >${WEB_ROOT}/CQPweb/lib/config.inc.php
<?php


/* ----------------------------------- *
 * adminstrators' usernames, separated *
 * by | with no stray whitespace.      *
 * ----------------------------------- */

\$superuser_username = '${CQPWEB_ADMIN}';


/* -------------------------- *
 * database connection config *
 * -------------------------- */

\$mysql_webuser = '${MYSQL_USER}';
\$mysql_webpass = '${MYSQL_PASSWORD}';
\$mysql_schema  = '${MYSQL_DATABASE}';
\$mysql_server  = 'sql';


/* ---------------------- *
 * server directory paths *
 * ---------------------- */

\$cqpweb_tempdir   = '${CACHE_VOL}';
\$cqpweb_uploaddir = '${UPLOAD_VOL}';
\$cwb_datadir      = '${CORPORA_VOL}';
\$cwb_registry     = '${REGISTRY_VOL}';

\$cqpweb_root_url  = '${CQPWEB_ROOT_URL}';

\$mysql_has_file_access = TRUE;

?>

EOF

#put symlinks to the exe directory for each of the corpora installed in
#the registry - this is how CQPweb does routing

for regfile in ${REGISTRY_VOL}/*; do
	target="${WEB_ROOT}/CQPweb/${regfile##*/}"
	if ! [[ $regfile =~ __freq$ || -e $target ]]
	then 
		echo "linking corpus ${target}"
		ln -s ${WEB_ROOT}/CQPweb/exe $target
	fi
done 

# ensure permissions are ok

chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} ${WEB_ROOT}

chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} ${UPLOAD_VOL}
chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} ${CACHE_VOL}
chmod -R 775 ${CACHE_VOL}

# Apache gets grumpy about PID files pre-existing
rm -f ${APACHE_PID_FILE}

exec apache2 -DFOREGROUND
