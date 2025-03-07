#!/bin/bash

service mariadb start
mariadb -e "CREATE DATABASE IF DOES NOT EXIST ${INCEPTION_MYSQL_DATATBASE}"
mariadb -e "CREATE USER IF DOES NOT EXIST '${INCEPTION_MYSQL_USER}'@'%' IDENTIFIED BY '${INCEPTION_MYSQL_PASS}'"
mariadb -e "GRANT ALL ON ${INCEPTION_MYSQL_DATABASE}.* TO '${INCEPTION_MY_SQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"
mysqladmin shutdown -u root
mysqld --bind-adress=0.0.0.0 --port=3306 --user=root