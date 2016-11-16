#!/usr/bin/env bash


echo "Setting up symlinks & home directory ..."

# Convenience Links From Home Directory
# ---------------------------
cd /home/vagrant
rm -rf html log conf
mkdir -p conf log
# ---------------------------
ln -fs /var/www/html    html
ln -fs /var/log/apache2 log/apache
ln -fs /var/log/mysql   log/mysql
ln -fs /etc/apache2     conf/apache
ln -fs /etc/mysql       conf/mysql
ln -fs /var/lib/mysql   conf/mysql-lib
ln -fs /etc/php/5.5     conf/php
ln -fs /usr/lib/php/20121212    conf/php-ext
chown -R vagrant:vagrant .


# Backup config files & replace with custom copies from vagrant directory
# ----------------------------
echo "Replacing MySQL config file (my.cnf) ..."
[ ! -f /etc/mysql/original-my.cnf ] && mv /etc/mysql/my.cnf /etc/mysql/original-my.cnf
cp -f /var/www/html/vagrant/my.cnf /etc/mysql/my.cnf


echo "Adjusting PHP Settings ..."
cp /var/www/html/vagrant/xdebug.ini /etc/php/5.5/mods-available/xdebug.ini

echo "Changing Apache to run as vagrant user ..."
# Replace www-data user with vagrant in /etc/apache2/envvars
sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/g" /etc/apache2/envvars
sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/g" /etc/apache2/envvars


# Restart Services
# ----------------
echo "Restarting MySQL service ..."
rm -f /var/lib/mysql/ib_logfile0 /var/lib/mysql/ib_logfile1
service mysql restart

echo "Restarting Apache service ..."
service apache2 restart


