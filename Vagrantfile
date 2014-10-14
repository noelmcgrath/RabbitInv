
Vagrant::configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  #config.vm.box = "noelrabbit"
  config.vm.network "forwarded_port", guest: 15672, host: 15672
  config.vm.network "forwarded_port", guest: 5672, host: 5672 
  
 
  # config.vm.provider "virtualbox" do |v|
    # v.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
  # end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"


  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.synced_folder "./", "/vagrant", create: true

  # Provision the development environment
 # config.vm.provision :shell , path: "provisionrabbit.sh"
end
