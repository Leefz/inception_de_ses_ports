#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html
chmod -R 755 /var/www/html
sed -i '36 s/\/run\/php\/php7.4-fpm.sock/9000/' /etc/php/7.4/fpm/pool.d/www.conf

for ((i = 1; i <= 10; i++)); do
    if mariadb -h mariadb -P 3306 \
        -u "${INCEPTION_MY_SQL_USER}" \
        -p"${INCEPTION_MY_SQL_PASS}" -e "SELECT 1" > /dev/null 2>&1; then
        break
    else
        sleep 2
    fi
done

wp core download --allow-root
wp config create \
    --dbname=${INCEPTION_MY_SQL_DATABASE} \
    --dbuser=${INCEPTION_MY_SQL_USER} \
    --dbpass=${INCEPTION_MY_SQL_PASS} \
    --dbhost=mariadb:3306 --allow-root
wp core install \
    --url=${INCEPTION_DOMAIN_NAME} \
    --title=${INCEPTION_WP_TITLE} \
    --admin_user=${INCEPTION_WP_A_NAME} \
    --admin_password=${INCEPTION_WP_A_PASS} \
    --admin_email=${INCEPTION_WP_A_EMAIL} --allow-root
wp user create ${INCEPTION_WP_U_NAME} ${INCEPTION_WP_U_EMAIL} \
    --user_pass=${INCEPTION_WP_U_PASS} \
    --role=${INCEPTION_WP_U_ROLE} --allow-root

wp theme install twentytwentyfour --activate --allow-root

chown -R www-data:www-data /var/www/html

mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 --nodaemonize -F