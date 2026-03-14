#!/bin/bash
set -e

ROOT_PASS=$(cat /run/secrets/db_root_password)
MYSQL_PASS=$(cat /run/secrets/db_password)

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Démarre MariaDB en arrière-plan
    mysqld --user=mysql --skip-networking &
    MYSQL_PID=$!

    # Attends que MariaDB soit prêt
    until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
        sleep 1
    done

    # Initialise la base
    mysql --socket=/run/mysqld/mysqld.sock <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Arrête le serveur temporaire
    kill $MYSQL_PID
    wait $MYSQL_PID
fi

exec mysqld --user=mysql --bind-address=0.0.0.0