module Vagrant
  module Provisioners
    class Simple < Base
      register :simple

      class Config < Vagrant::Config::Base
        attr_accessor :commands

        def initialize
          @commands = []
        end
      end

      def provision!
        env.ui.info "Running commands on host..."
        vm.ssh.execute do |ssh|
          config.commands.each do |command|
            env.ui.info "* #{command}"
            ssh.exec!(command)
          end
        end
      end
    end
  end
end

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "freebsd81-amd64-zfs"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://mckusick.pil.dk/packages/freebsd81-amd64-zfs.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port "http", 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data")

  host = "locobad.pil.dk"
  config.vm.provision :simple, :commands => [
    "sudo pkg_add http://mckusick.pil.dk/packages/mckusick.pil.dk/perl-5.8.9_4.tbz",
    "fetch http://mckusick.pil.dk/packages/upgrade_packages.pl",
    "echo BASEPKGHOST=mckusick.pil.dk >/tmp/piltools-globals.conf",
    "sudo mv /tmp/piltools-globals.conf /usr/local/etc/",
    "sudo rm -rf /var/db/pkg/virtualbox-ose-additions*",
    "echo y | sudo perl upgrade_packages.pl --host #{host}",
    "echo y | sudo perl upgrade_packages.pl --host #{host}",
    "echo y | sudo perl upgrade_packages.pl --host #{host}",
  ]

  config.vm.share_folder('v-root', '/vagrant', '.', :nfs => true)
  config.vm.network("192.168.10.10")
end
