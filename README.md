# Gearx Vagrant LAMP Box
A Vagrant configuration for building a LAMP base box

* Ubuntu 14.04 - Trusty Tahr
* Apache 2
* MySQL 5.5 (Percona)
* PHP 5.5
* Ruby 2.0
* vim, git, sendmail, xdebug, ioncube

#### Build the VM

    vagrant up


#### Package VM into a Vagrant Box

    vagrant package --output gearx-lamp.box
    
    
#### Destroy the running VM

    vagrant destroy
    
    
#### Add the box to your Vagrant Install

    vagrant box add gearx-lamp gearx-lamp.box
    
    
Now more specific boxes can be built off this base box by includeing this line in their Vagrantfile

    config.vm.box = "gearx-lamp"
    
    
