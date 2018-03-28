# -*- mode: ruby -*-
# vi: set ft=ruby :

## SSH user in case you want to use non-vagrant accounts
vagrant_user = "vagrant"
vagrant_command = ARGV[0]

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.2"
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    config.vbguest.auto_update = false
    # dump our static hosts file in
    config.vm.provision "shell",
      inline: "cp /vagrant/local_hosts /etc/hosts"
  end

  config.ssh.forward_agent = true

  # Use a "real" user for interactive logins
  if  ['ssh', 'scp'].include? vagrant_command
    config.ssh.username = vagrant_user
  end

  config.vm.provider :virtualbox do |v|
    v.cpus = 4
    v.memory = 4096
    v.linked_clone = true
  end

  config.vm.provision "shell" do |shell|
    shell.path = "scripts/bootstrap.sh"
    shell.keep_color = "True"
  end
  
end
