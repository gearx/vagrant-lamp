#!/usr/bin/env bash


# Add PHP and Percona Repos, then update Apt
# --------------------
add-apt-repository -y ppa:ondrej/php

wget -nv https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
rm -f percona-release_0.1-4.trusty_all.deb

apt-get update


# Install some basic tools
# --------------------
apt-get install -y nfs-common libcurl3 vim git sendmail


# Install Apache & PHP
# --------------------
apt-get install -y apache2

apt-get install -y php5.5 php5.5-mcrypt php5.5-curl php5.5-cli php5.5-mysql php5.5-gd php5.5-xml php5.5-soap php5.5-mbstring php-xdebug libapache2-mod-php5



# Replace contents of default Apache vhost
# --------------------
VHOST=$(cat <<EOF
NameVirtualHost *:8080
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
service apache2 restart


# Remove default Apache file from web root
# ----------------
rm -f /var/www/html/index.html


# Install Percona (MySQL)
# -----------------------
# Prep root password for noninteractive install
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "percona-server-server-5.5 percona-server-server/root_password password mysql"
sudo debconf-set-selections <<< "percona-server-server-5.5 percona-server-server/root_password_again password mysql"

# Install Percona Server
apt-get -q -y install percona-server-server-5.5

# Grant Priveledges for direct connection from host
GRANT=$(cat <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'
    IDENTIFIED BY 'mysql'
    WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
)

mysql -uroot -pmysql -e "$GRANT"



# Install IonCube for PHP
# ------------------------
echo "Installing IonCube Loader ..."
wget -nv http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -zxvf ioncube_loaders_lin_x86-64.tar.gz
rm ioncube_loaders_lin_x86-64.tar.gz

cp ioncube/ioncube_loader_lin_5.5.so ioncube/ioncube_loader_lin_5.5_ts.so /usr/lib/php/20121212/
rm -rf ioncube

echo "zend_extension = ioncube_loader_lin_5.5.so" > /etc/php/5.5/mods-available/ioncube.ini
ln -fs /etc/php/5.5/mods-available/ioncube.ini /etc/php/5.5/apache2/conf.d/05-ioncube.ini
ln -fs /etc/php/5.5/mods-available/ioncube.ini /etc/php/5.5/cli/conf.d/05-ioncube.ini


# Install RVM & Ruby so it's ready to go for installing any dependencies
# Switch to vagrant user session so rvm is installed properly, then exit after
# -------------------
apt-get -y remove ruby
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL get.rvm.io | bash -s stable --ignore-dotfiles
source /usr/local/rvm/scripts/rvm
usermod -a -G rvm vagrant

su - vagrant -c "rvm --quiet-curl install 2.0.0"
su - vagrant -c "gem update -q --system"


