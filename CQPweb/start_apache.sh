#!/bin/sh

set -e

cat <<EOF >/var/www/html/CQPweb/lib/config.inc.php
<?php


/* ----------------------------------- *
 * adminstrators' usernames, separated *
 * by | with no stray whitespace.      *
 * ----------------------------------- */

/* Hello there test env = ${TEST_ENV}*/


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

\$cqpweb_tempdir   = '/var/cqpweb/tmp';
\$cqpweb_uploaddir = '/var/cqpweb/upload';
\$cwb_datadir      = '/var/corpora';
\$cwb_registry     = '/usr/local/share/cwb/registry';

\$mysql_has_file_access = TRUE;

?>

EOF

# Apache gets grumpy about PID files pre-existing
rm -f ${APACHE_PID_FILE}

exec apache2 -DFOREGROUND
