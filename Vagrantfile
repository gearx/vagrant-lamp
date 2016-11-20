# -*- mode: ruby -*-
# vi: set ft=ruby :


required_plugins = %w( vagrant-vbguest )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end


Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.define "gearx-lamp-base" do |lamp|
  end

  config.vm.provision "file",   source: "setphp.sh", destination: "~/setphp.sh"
  config.vm.provision "file",   source: "xdebug.ini", destination: "~/xdebug.ini"
  config.vm.provision "install",  type: "shell",  path: "install.sh"
  config.vm.provision "config",   type: "shell",  path: "config.sh"
  config.vm.provision "cleanup",   type: "shell",  path: "cleanup.sh"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.ssh.forward_agent = true

  # It's tempting to assign more than one cpu, but DON'T DO IT!!  Multiple cpus
  # will slow down the VM due to the way VirtualBox processor scheduling works.
  # http://www.mihaimatei.com/virtualbox-performance-issues-multiple-cpu-cores/

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 1
    vb.name = "vagrant-gearx-lamp-base"
  end

end




