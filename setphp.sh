#!/usr/bin/env bash

# A Script for changing the active version of PHP

function displayDefault {
    WebPhpVersion=$(ls /etc/apache2/mods-enabled | grep php.*.conf | sed 's/\.conf//' | sed 's/php/PHP /')
    CliPhpVersion=$(php -version | head -1 | cut -c1-7)
    echo "Currently Active PHP Version:   Apache: $WebPhpVersion   CLI: $CliPhpVersion"
    echo "To Switch Versions:   setphp 5.5|55|5.6|56|7.0|70|7"
}


if [[ $1 == '55' || $1 == '5.5' ]]; then
    version='5.5'
elif [[ $1 == '56' || $1 == '5.6' ]]; then
    version='5.6'
elif [[ $1 == '7' || $1 == '70' || $1 == '7.0' ]]; then
    version='7.0'
else
    displayDefault
    exit
fi

# Switch to PHP command line version
sudo ln -sfn /usr/bin/php${version} /etc/alternatives/php

echo "Enabling cli php ${version}"

# Disable all Apache module versions
sudo a2dismod -q php5.5 php5.6 php7.0

# Enable new Apache module version
sudo a2enmod -q php${version}

# Restart Apache
sudo service apache2 restart

echo -e "\e[32mPHP ${version} Enabled \e[39m"
