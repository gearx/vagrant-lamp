# Gearx Vagrant LAMP Box
A Vagrant configuration for building a LAMP base box

* Ubuntu 14.04 - Trusty Tahr
* Apache 2
* MySQL 5.5 (Percona)
* PHP 5.5
* Ruby 2.0
* vim, git, sendmail, xdebug, ioncube

## Using This Base Box

This base box is hosted here on Hashicorp Atlas https://atlas.hashicorp.com/gearx/boxes/lamp/.
To create a dev environment from it, add this to a project's Vagrantfile:

    Vagrant.configure("2") do |config|
    
        config.vm.box = "gearx/lamp"
    
    end




## Packaging The Base Box For Testing

These are the steps required to build and test a new version of the base box.

#### Build the VM

    vagrant up


#### Package VM into a Vagrant Box

    vagrant package --output gearx-lamp.box
    
    
#### Destroy the running VM

    vagrant destroy
    
    
#### Add the box to your Vagrant Install and Test It

    vagrant box add gearx-lamp gearx-lamp.box
    
    
Test using the base box in a projecrt by including this line in a new Vagrantfile and running `vagrant up`

    Vagrant.configure("2") do |config|
    
        config.vm.box = "gearx-lamp"
    
    end
    
#### Upload To Hashicorp Atlas

Upload the generated gearx-lamp.box file to the Hashicorp Atlas the the web interface.

    
