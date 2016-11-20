#!/usr/bin/env bash


echo "Adding PHP and Percona Repos ..."
# --------------------
add-apt-repository -y ppa:ondrej/php

wget -nv https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
rm -f percona-release_0.1-4.trusty_all.deb

apt-get update


echo "Installing some basic tools ..."
# --------------------
apt-get install -y nfs-common libcurl3 vim git sendmail


echo "Installing Apache ..."
# --------------------
apt-get install -y apache2

echo "Installing PHP 5.5 and modules ..."
# --------------------
apt-get install -y php5.5 php5.5-mcrypt php5.5-curl php5.5-cli php5.5-mysql php5.5-gd php5.5-xml php5.5-soap php5.5-mbstring php-xdebug libapache2-mod-php5.5

echo "Installing PHP 5.6 and modules ..."
# --------------------
apt-get install -y php5.6 php5.6-mcrypt php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-xml php5.6-soap php5.6-mbstring php-xdebug libapache2-mod-php5.6

echo "Installing PHP 7.0 and modules ..."
# --------------------
apt-get install -y php7.0 php7.0-mcrypt php7.0-curl php7.0-cli php7.0-mysql php7.0-gd php7.0-xml php7.0-soap php7.0-mbstring php-xdebug libapache2-mod-php7.0


# Install setphp script as shell command
# --------------------
mv /home/vagrant/setphp.sh /usr/local/bin/setphp



echo "Installing Percona 5.5 (MySQL) ..."
# --------------------
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



echo "Installing IonCube Loader PHP module ..."
# --------------------
wget -nv http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -zxvf ioncube_loaders_lin_x86-64.tar.gz
rm ioncube_loaders_lin_x86-64.tar.gz

cp ioncube/ioncube_loader_lin_5.5.so ioncube/ioncube_loader_lin_5.5_ts.so /usr/lib/php/20121212/
cp ioncube/ioncube_loader_lin_5.6.so ioncube/ioncube_loader_lin_5.6_ts.so /usr/lib/php/20131226/
cp ioncube/ioncube_loader_lin_7.0.so ioncube/ioncube_loader_lin_7.0_ts.so /usr/lib/php/20151012/
rm -rf ioncube

echo "zend_extension = ioncube_loader_lin_5.5.so" > /etc/php/5.5/mods-available/ioncube.ini
ln -fs /etc/php/5.5/mods-available/ioncube.ini /etc/php/5.5/apache2/conf.d/05-ioncube.ini
ln -fs /etc/php/5.5/mods-available/ioncube.ini /etc/php/5.5/cli/conf.d/05-ioncube.ini
echo "zend_extension = ioncube_loader_lin_5.6.so" > /etc/php/5.6/mods-available/ioncube.ini
ln -fs /etc/php/5.6/mods-available/ioncube.ini /etc/php/5.6/apache2/conf.d/05-ioncube.ini
ln -fs /etc/php/5.6/mods-available/ioncube.ini /etc/php/5.6/cli/conf.d/05-ioncube.ini
echo "zend_extension = ioncube_loader_lin_7.0.so" > /etc/php/7.0/mods-available/ioncube.ini
ln -fs /etc/php/7.0/mods-available/ioncube.ini /etc/php/7.0/apache2/conf.d/05-ioncube.ini
ln -fs /etc/php/7.0/mods-available/ioncube.ini /etc/php/7.0/cli/conf.d/05-ioncube.ini


echo "Installing RVM ..."
# Switch to vagrant user session so rvm is installed properly, then exit after
# --------------------
apt-get -y remove ruby
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL get.rvm.io | bash -s stable --ignore-dotfiles
source /usr/local/rvm/scripts/rvm
usermod -a -G rvm vagrant

echo "Installing Ruby 2.0.0 ..."
# --------------------
su - vagrant -c "rvm --quiet-curl install 2.0.0"
su - vagrant -c "gem update -q --system"


