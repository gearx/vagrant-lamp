#!/usr/bin/env bash


echo "Customizing Shell Prompt ..."
# ---------------------------
CustomPrompt='export PS1="[\[\033[38;5;3m\]\u@\h \[\033[38;5;4m\]\W\[$(tput sgr0)\]]$ "'
echo -e "\n" >> /home/vagrant/.profile
echo -e "\n" >> /root/.profile
echo "${CustomPrompt}" >> /home/vagrant/.profile
echo "${CustomPrompt}" >> /root/.profile


echo "Creating Convenience Links From Home Directory ..."
# ---------------------------
cd /home/vagrant
rm -rf html log conf
mkdir -p conf log
ln -fs /var/www/html    html
ln -fs /var/log/apache2 log/apache
ln -fs /var/log/mysql   log/mysql
ln -fs /etc/apache2     conf/apache
ln -fs /etc/mysql       conf/mysql
ln -fs /var/lib/mysql   conf/mysql-lib
ln -fs /etc/php/5.5     conf/php5.5
ln -fs /etc/php/5.6     conf/php5.6
ln -fs /etc/php/7.0     conf/php7.0
sudo ln -fs /usr/lib/php/20121212    /etc/php/5.5/extension
sudo ln -fs /usr/lib/php/20131226    /etc/php/5.6/extension
sudo ln -fs /usr/lib/php/20151012    /etc/php/7.0/extension
chown -R vagrant:vagrant .


echo "Replacing MySQL config file (my.cnf) ..."
# ---------------------------
[ ! -f /etc/mysql/original-my.cnf ] && mv /etc/mysql/my.cnf /etc/mysql/original-my.cnf
mv /home/vagrant/my.cnf /etc/mysql/my.cnf


echo  "Creating Custom PHP ini for overrides ..."
# ---------------------------
touch /etc/php/5.5/php-custom.ini /etc/php/5.6/php-custom.ini /etc/php/7.0/php-custom.ini
ln -fs /etc/php/5.5/php-custom.ini /etc/php/5.5/cli/conf.d/01-php-custom.ini
ln -fs /etc/php/5.5/php-custom.ini /etc/php/5.5/apache2/conf.d/01-php-custom.ini
ln -fs /etc/php/5.6/php-custom.ini /etc/php/5.6/cli/conf.d/01-php-custom.ini
ln -fs /etc/php/5.6/php-custom.ini /etc/php/5.6/apache2/conf.d/01-php-custom.ini
ln -fs /etc/php/7.0/php-custom.ini /etc/php/7.0/cli/conf.d/01-php-custom.ini
ln -fs /etc/php/7.0/php-custom.ini /etc/php/7.0/apache2/conf.d/01-php-custom.ini

echo  "Configuring xDebug ..."
# ---------------------------
cp /home/vagrant/xdebug.ini /etc/php/5.5/mods-available/xdebug.ini
cp /home/vagrant/xdebug.ini /etc/php/5.6/mods-available/xdebug.ini
cp /home/vagrant/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini


echo "Changing Apache to run as vagrant user ..."
# ---------------------------
# Replace www-data user with vagrant in /etc/apache2/envvars
sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/g" /etc/apache2/envvars
sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/g" /etc/apache2/envvars


echo "Setting Up Apache virtual hosts ..."
# ---------------------------
VHOST=$(cat <<EOF
Listen 8080
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:8080>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)

echo "$VHOST" > /etc/apache2/sites-enabled/000-default.conf

a2enmod rewrite

# Remove default Apache file from web root
rm -f /var/www/html/index.html


echo "Restarting MySQL service ..."
# ---------------------------
rm -f /var/lib/mysql/ib_logfile0 /var/lib/mysql/ib_logfile1
service mysql restart


echo "Enabling PHP 5.6 and restarting Apache ..."
# ---------------------------
setphp 5.6
