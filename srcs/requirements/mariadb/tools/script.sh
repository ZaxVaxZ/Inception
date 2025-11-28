#!/usr/bin/env bash
set -e

# create run directory and set owner
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Ensure config file has required values
if ! grep -q "^\[mysqld\]" "$DB_CONF_ROUTE"; then
    echo "[mysqld]" >> "$DB_CONF_ROUTE"
fi
if ! grep -q "^bind-address=0.0.0.0" "$DB_CONF_ROUTE"; then
    echo "bind-address=0.0.0.0" >> "$DB_CONF_ROUTE"
fi

# Adjust port and bind address if needed
if grep -q "^# port = 3306" "$DB_CONF_ROUTE"; then
    sed -i 's/^# port = 3306/port = 3306/' "$DB_CONF_ROUTE"
fi

if grep -q "127.0.0.1" /etc/mysql/mariadb.conf.d/50-server.cnf; then
    sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
fi

if [ ! -d "$DB_INSTALL/mysql" ]; then
  mysql_install_db --user=mysql --datadir="$DB_INSTALL" --rpm --auth-root-authentication-method=normal
fi

  cat > /tmp/init.sql <<-EOSQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
CREATE USER IF NOT EXISTS '$WP_ADMIN_USER'@'%' IDENTIFIED BY '$WP_ADMIN_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$WP_ADMIN_USER'@'%';
FLUSH PRIVILEGES;
EOSQL

  # Run bootstrap SQL once
  mysqld --user=mysql --datadir="$DB_INSTALL" --bootstrap < /tmp/init.sql
  rm -f /tmp/init.sql

# Finally start MariaDB normally in the foreground (container main process)
mysqld_safe --datadir="$DB_INSTALL"
