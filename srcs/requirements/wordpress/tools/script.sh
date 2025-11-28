#!/usr/bin/env bash

# wait for MariaDB before starting up
until mysql -h"mariadb" -P"3306" -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1;" >/dev/null 2>&1; do
  echo "Waiting for MariaDB"
  sleep 1
done
echo "Mariadb has successfully started"

cd $WP_ROUTE 2>/dev/null || mkdir -p $WP_ROUTE && cd $WP_ROUTE

wp core download --force --allow-root

wp config create --path=$WP_ROUTE --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb --dbprefix=wp_
if [ -e wp-config.php ]; then
    echo "Config file successfully created"
else
    echo "Config file wasn't created"
fi

if ! wp core is-installed --allow-root --path=$WP_ROUTE; then
wp core install --url="$WP_URL" --title="ehammoud" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --allow-root
wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS --allow-root
fi

php-fpm8.2 -F
