# -*- mode: ruby -*-
# vi: set ft=ruby :

# NOTE: 
# This VM will contain an apache web server inside it that
# serves the zeeguu web on http://www.zeeguu.local:8080
# and the API on http://api.zeeguu.local:8080
# To be able to access them you have to add to your 
# /etc/hosts the following two lines
# 
#   127.0.0.1 www.zeeguu.local
#   127.0.0.1 api.zeeguu.local
# 
# Besides that, the mysql DB from the VM will be available 
# on port 13306 on your 127.0.0.1
# 


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/bionic64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # make the SQL servers available at 1<original port>
  config.vm.network "forwarded_port", guest: 3306, host: 13306, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3307, host: 13307, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
  
    # Customize the amount of memory on the VM:
    vb.memory = "4024"
  end

  config.disksize.size = '20GB'

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  $first_boot = <<-SHELL
    apt-get update
    apt-get install docker.io -y

    cd /vagrant
    bash setup_development.sh

    sudo usermod -aG docker vagrant

    echo "press enter to reboot; that will ensure that vagrant user has been added to the docker group"
    read
    reboot

  SHELL

  $every_boot = <<-SHELL
    bash prepare_for_develop.sh
  SHELL

  config.vm.provision "shell", inline: $first_boot
  config.vm.provision "shell", inline: $every_boot, run: 'always'


end
