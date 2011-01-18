module Vagrant
  module Provisioners
    # This class implements provisioning via simple commands. Commands can be
    # registered to run after init and after boot, on host and in VM.
    class Simple < Base
      register :simple

      class SimpleError < Errors::VagrantError
        error_namespace("vagrant.provisioners.simple")
      end

      class Config < Vagrant::Config::Base
        attr_reader :commands

        def initialize
          @commands = []
        end
        
        def add_command(after, where, command)
          raise SimpleError, :invalid_after_spec unless [:init, :boot].include?(after)
          raise SimpleError, :invalid_where_spec unless [:guest, :host].include?(where)
          @commands << [:run, after, where, command]
        end
        
        def copy_file(after, source, dest)
          raise SimpleError, :invalid_after_spec unless [:init, :boot].include?(after)
          raise SimpleError, :no_source_file unless File.exist?(source)
          @commands << [:copy, after, source, dest]
        end
      end

      def provision!
        config_key = "#{self.class.to_s}:init_done"
        first_run = false

        if config.env.parent and not config.env.parent.local_data.has_key?(config_key)
          first_run = true
          config.env.parent.local_data[config_key] = first_run
          config.env.parent.local_data.commit
        end

        vm.ssh.execute do |ssh|
          config.commands.each do |type, after, *args|
            next if after == :init and !first_run

            case type
            when :run
              where, command = args

              if where == :guest
                env.ui.info "* (vm) #{command}"
                ssh.exec!(command)
              elsif where == :host
                env.ui.info "* (host) #{command}"
                system command
              end
            when :copy
              source, dest = args
              vm.ssh.upload!(source, dest)
            else
              raise SimpleError, :unknown_command
            end
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
  config.vm.box = "freebsd81-amd64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://mckusick.pil.dk/packages/freebsd81-amd64.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port "http", 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data")

  host = "locobad.pil.dk"
  config.vm.provision :simple do |s|
    s.add_command(:init, :guest, 'sudo pkg_add http://mckusick.pil.dk/packages/mckusick.pil.dk/perl-5.8.9_4.tbz')
    s.add_command(:init, :guest, 'fetch http://mckusick.pil.dk/packages/upgrade_packages.pl')
    s.add_command(:init, :guest, 'echo BASEPKGHOST=mckusick.pil.dk >/tmp/piltools-globals.conf')
    s.add_command(:init, :guest, 'sudo mv /tmp/piltools-globals.conf /usr/local/etc/')
    s.add_command(:init, :guest, 'sudo rm -rf /var/db/pkg/virtualbox-ose-additions*')
    s.add_command(:init, :guest, "echo y | sudo perl upgrade_packages.pl --host #{host}")
    s.add_command(:init, :guest, "echo y | sudo perl upgrade_packages.pl --host #{host}")
    s.add_command(:init, :guest, "echo y | sudo perl upgrade_packages.pl --host #{host}")
    s.add_command(:init, :guest, 'echo mongod_enable="YES" >>/etc/rc.conf')
    s.add_command(:init, :guest, 'sudo /usr/local/etc/rc.d/mongod start')

    s.add_command(:boot, :guest, "cd /vagrant ; env RB_USER_INSTALL=yes bundle install --deployment --path /home/vagrant/.bundle --without dev")
    s.copy_file(:boot, "config/vagrant/nginx.conf", "/home/vagrant/nginx.conf")
    s.add_command(:boot, :guest, "sudo mv /home/vagrant/nginx.conf /usr/local/etc/nginx/nginx.conf")
    s.add_command(:boot, :guest, "cd /vagrant ; bundle exec unicorn -c config/vagrant/unicorn.rb -D -E production")
    s.add_command(:boot, :guest, "sudo /usr/local/etc/rc.d/nginx onestart")
  end

  config.vm.share_folder('v-root', '/vagrant', '.', :nfs => true)
  config.vm.network("192.168.10.10")
end
