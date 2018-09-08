# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'json'

Vagrant.configure("2") do |config| #The "2" represents the version of the configuration object config 
config.vm.synced_folder "shared", "/home/vagrant/shared"
	
	if(File.file?('servers1.json'))
		guests = JSON.parse(File.read('servers1.json'))
		puts 'json exists'
	
		guests.each do |guest|
			
			config.vm.define guest['name'] do |guest_vm|
				guest_vm.vm.box = guest['box']
				guest_vm.vm.network 'private_network', ip: guest['private_ip']
				guest_vm.vm.synced_folder "shared/only_json_vm", "/home/vagrant/shared"
				guest_vm.vm.provider "virtualbox" do |vb|
					vb.memory = guest ['memory']
					vb.cpus = guest ['cpus']
				end
			end
		end
  
 
	else
		guests = YAML.load_file("guest_machines.yml")
		puts 'yml exists'


		guests.each do |guest|
			config.vm.define guest['name'] do |guest_vm|
				cpu_mem(guest, guest_vm)
				box(guest, guest_vm)
				network_conf(guest, guest_vm)
				services(guest, guest_vm)
				guest_vm.vm.synced_folder "shared", "/home/vagrant/shared"
				scripts(guest, guest_vm)
			end
		end
  
	def cpu_mem(guest, guest_vm)
		guest_vm.vm.provider "virtualbox" do |vb|
			vb.cpus = guest['cpus']
			vb.memory = guest['memory'] 
		end
	end

	def box(guest, guest_vm)
		guest_vm.vm.box = guest['box']
	end
  
	def network_conf(guest, guest_vm)
		guest_vm.vm.network "private_network", ip: guest['private_ip']
	end

	def services(guest, guest_vm)
		if guest['package_manager'] == "apk"
			guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} update -y"
		elsif guest['package_manager'] == "apt"
			guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} update -y"
		else
		guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} update -y"
		#guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} install -y #{guest['packages']}"
		#guest_vm.vm.provision "shell", privileged: false, path: "vagrant_script/python_server.sh"
		#guest_vm.vm.provision "shell", privileged: false, path: "vagrant_script/jenkins_server.sh"
		#guest_vm.vm.network "forwarded_port", guest: 9000, host: guest['port_for']
		
		end
	end
	
	def scripts(guest, guest_vm)
		guest['scripts'].each do |script|
			guest_vm.vm.provision "shell", privileged: false, path: "vagrant_script/#{script}"
		end
	end


	  # Every Vagrant development environment requires a box. You can search for
	  # boxes at https://vagrantcloud.com/search.
	  #config.vm.define "jenkins" do |jenkins|
		#jenkins.vm.box = "centos/7"
		#jenkins.vm.provider "virtualbox" do |vb|
		#	vb.memory = 2048
		#	vb.cpus = 2
		#end
	  
		#jenkins.vm.provision "shell", path: "vagrant_script/python_server.sh"      #inline: "echo Hello, World"
		#jenkins.vm.network "forwarded_port", guest: 9000, host: 9000
	  #end
		#config.vm.define "ab" do |ab|
		#ab.vm.box = "centos/7"
		#ab.vm.provider "virtualbox" do |vb|
		#	vb.memory = 1048
		#	vb.cpus = 1
		#end
	  
		#ab.vm.provision "shell", path: "vagrant_script/python_server.sh"      #inline: "echo Hello, World"
		#ab.vm.network "forwarded_port", guest: 9000, host: 9001
	 #end
	  #or
	  #config.vm.provision "shell", inline: <<-SHELL
		#sudo yum install -y git
		#sudo yum update
		#sudo useradd jenkins
		#sudo git clone https://github.com/bob-crutchley/python-systemd-http-server.git && cd python-systemd-http-server
		#sudo make install
		#sudo systemctl daemon-reload
		#sudo systemctl start python-systemd-http-server.service
		#sudo systemctl status python-systemd-http-server.service
	  #SHELL
	
  
	  # Disable automatic box update checking. If you disable this, then
	  # boxes will only be checked for updates when the user runs
	  # `vagrant box outdated`. This is not recommended.
	  # config.vm.box_check_update = false

	  # Create a forwarded port mapping which allows access to a specific port
	  # within the machine from a port on the host machine. In the example below,
	  # accessing "localhost:8080" will access port 80 on the guest machine.
	  # NOTE: This will enable public access to the opened port
	  # config.vm.network "forwarded_port", guest: 9000, host: 9000

	  # Create a forwarded port mapping which allows access to a specific port
	  # within the machine from a port on the host machine and only allow access
	  # via 127.0.0.1 to disable public access
	  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

	  # Create a private network, which allows host-only access to the machine
	  # using a specific IP.
	  # config.vm.network "private_network", ip: "192.168.33.10"

	  # Create a public network, which generally matched to bridged network.
	  # Bridged networks make the machine appear as another physical device on
	  # your network.
	  # config.vm.network "public_network"

	  # Share an additional folder to the guest VM. The first argument is
	  # the path on the host to the actual folder. The second argument is
	  # the path on the guest to mount the folder. And the optional third
	  # argument is a set of non-required options.
	  # config.vm.synced_folder "../data", "/vagrant_data"

	  # Provider-specific configuration so you can fine-tune various
	  # backing providers for Vagrant. These expose provider-specific options.
	  # Example for VirtualBox:
	  #
	  # config.vm.provider "virtualbox" do |vb|
	  #   # Display the VirtualBox GUI when booting the machine
	  #   vb.gui = true
	  #
	  #   # Customize the amount of memory on the VM:
	  #   vb.memory = "1024"
	  # end
	  #
	  # View the documentation for the provider you are using for more
	  # information on available options.

	  # Enable provisioning with a shell script. Additional provisioners such as
	  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
	  # documentation for more information about their specific syntax and use.
	  # config.vm.provision "shell", inline: <<-SHELL
	  #   apt-get update
	  #   apt-get install -y apache2
	  # SHELL
	end
end