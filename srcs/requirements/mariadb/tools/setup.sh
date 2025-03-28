#!/bin/bash

mysql_install_db
service mariadb start
mysql_secure_installation << EOF

n
n
n
y
n
y
y
EOF
sed -i 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
mariadb -u root -e "CREATE DATABASE IF NOT EXISTS ${INCEPTION_MY_SQL_DATABASE}"
mariadb -u root -e "CREATE USER IF NOT EXISTS '${INCEPTION_MY_SQL_USER}'@'%' IDENTIFIED BY '${INCEPTION_MY_SQL_PASS}'"
mariadb -u root -e "GRANT ALL ON ${INCEPTION_MY_SQL_DATABASE}.* TO '${INCEPTION_MY_SQL_USER}'@'%';"
mariadb -u root -e "FLUSH PRIVILEGES;"
mysqladmin shutdown -u root 
mariadbd