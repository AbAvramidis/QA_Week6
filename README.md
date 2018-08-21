# QA_Week6

# Vagrant

Vagrant - Hypervisor - control manage and monitor the VMs creation, installation and maintenance processes.
#   Day tips:

  - mkdir .... && cd $_
  - Port forwarding with: config.vm.network "forwarded_port", guest: 9000, host: 9000

# Vagrant Commands!
    - vagrant up
    - vagrant ssh "VM name"
    - vagrant destroy
    - vagrant halt

# Vagrantfile configuration

  -  1st way to configure:
            
    Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
        config.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 2
        end
    end

 - 2nd way to configure:
                
       config.vm.define "jenkins" do |jenkins|
          jenkins.vm.box = "centos/7"
          jenkins.vm.provider "virtualbox" do |vb|
              vb.memory = 2048
              vb.cpus = 2
          end
          jenkins.vm.provision "shell", path: "vagrant_script/python_server.sh"
          jenkins.vm.network "forwarded_port", guest: 9000, host: 9000
       end
        
       config.vm.define "ab" do |ab|
          ab.vm.box = "centos/7"
          ab.vm.provider "virtualbox" do |vb|
            vb.memory = 1048
            vb.cpus = 1
          end
          ab.vm.provision "shell", path: "vagrant_script/python_server.sh"
          ab.vm.network "forwarded_port", guest: 9000, host: 9001
       end
 
  - 3rd way by combining into a do loop
  
        Vagrant.configure("2") do |config|
          guests.each do |guest|
            config.vm.define guest['name'] do |guest_vm|
                guest_vm.vm.box = guest['box']
                guest_vm.vm.provider "virtualbox" do |vb|
                  vb.cpus = guest['cpus']
                  vb.memory = guest['memory']
                end
            guest_vm.vm.network "private_network", ip: guest['private_ip']
            guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} update -y"
            guest_vm.vm.provision "shell", privileged: false, path: "vagrant_script/python_server.sh"
            guest_vm.vm.network "forwarded_port", guest: 9000, host: guest['port_for']
            end
          end
        end

  - 4th way by using functions - YML file
        
         require 'yaml'
         guests = YAML.load_file("guest_machines.yml")
         Vagrant.configure("2") do |config|
              guests.each do |guest|
                config.vm.define guest['name'] do |guest_vm|
                    cpu_mem(guest, guest_vm)
                    box(guest, guest_vm)
                    network_conf(guest, guest_vm)
                    services(guest, guest_vm)
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
            guest_vm.vm.provision "shell", inline: "sudo #{guest['package_manager']} update -y"
            guest_vm.vm.provision "shell", privileged: false, path: "vagrant_script/python_server.sh"
            guest_vm.vm.network "forwarded_port", guest: 9000, host: guest['port_for']
        end

# Example of a YML file (VMs)

    - name: jenkins
      box: centos/7
      cpus: 2
      memory: 4096 
      private_ip: 10.0.10.10
      package_manager: yum
      port_for: 9000
      packages:
      - wget
      - unzip
      - git
      scripts:
      - startup
      
 # Note: for synced folders the VirtualBox Guest Additions plugin must be installed for Vagrant:  
 
    -  vagrant plugin install vagrant-vbguest
    
    config.vm.synced_folder "shared", "/home/vagrant/shared"
    
- Basically, you can copy anything through the VM into the shared folder and see it or take it from
your host machine in that folder
Is a mapped/ mounted folder

# Implement a JSON file

| good web source url: | [https://blog.scottlowe.org/2016/01/18/multi-machine-vagrant-json/]

 - At first check if a JSON file exists or a YMAL file.
 
        if(File.file?('servers.json'))
          servers = JSON.parse(File.read('servers.json'))
          puts 'json exists'
        else
          guests = YAML.load_file("guest_machines.yml")
          puts 'yml exists'
        end
        
        
  -  At the top of the vagrantfile add:
       
          require 'json'
          servers = JSON.parse(File.read('servers.json'))

 - Example of VMs box definition:
     
        [{
          "name": "server",
          "box": "centos/7",
          "ram": 512,
          "vcpu": 1,
          "ip_addr": "10.10.10.10"
        }]
        
 - Vagrantfile code for JSON:
 
        Vagrant.configure("2") do |config|

        config.vm.synced_folder "shared", "/home/vagrant/shared"

          servers.each do |server|
             config.vm.define server['name'] do |srv|
                srv.vm.box = server['box']
                srv.vm.network 'private_network', ip: server['ip_addr']
                srv.vm.provider "virtualbox" do |vb|
                    vb.memory = server ['ram']
                    vb.cpus = server ['vcpu']
                end
            end
        end

# Ruby Lambdas Scripts Examples

- Create a ruby script, writing at the top:

      #!/usr/bin/env ruby
   
- Define a function and call it at the end:

      def fun
        say_hello = lambda { |name| print "#{name}\n" }
        say_hello.call("ab")
        
        sayhello = -> (name) { print "#{name}\n" }
        sayhello["ilias"]
      end
      fun
      
- Another example of ruby methods with arguments:
    
      test_function = lambda { |name| print "#{name}\n"}
      def run_it(func)
        func
      end
      
      run_it(test_function["hi"])
      run_it(test_function.call("ab"))
      
  
      
