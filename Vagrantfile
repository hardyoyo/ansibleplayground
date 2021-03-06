# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO: add a user for hpottinger, add it to sudo

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "geerlingguy/centos6"

  # define this box so Vagrant doesn't call it "default"
  config.vm.define "ansibleplayground"

  # Hostname for virtual machine
  config.vm.hostname = "apg.vagrant.dev"

  # BEGIN Landrush (https://github.com/phinze/landrush) configuration
    # This section will only be triggered if you have installed "landrush"
    #     vagrant plugin install landrush
    if Vagrant.has_plugin?('landrush')
        config.landrush.enabled = true
        config.landrush.tld = 'vagrant.dev'

        # let's use the Google free DNS
        config.landrush.upstream '8.8.8.8'
        config.landrush.guest_redirect_dns = false
    end
    # END Landrush configuration

    if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on the "Usage" link above
        config.cache.scope = :box
    end


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

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
  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     #vb.gui = true
  #
     # Customize the amount of memory on the VM:
     vb.memory = "2048"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

# disable insertion of the ssh key, because it's broken
config.ssh.insert_key = false

    #------------------------
    # Enable SSH Forwarding
    #------------------------
    # Turn on SSH forwarding (so that 'vagrant ssh' has access to your local SSH keys, and you can use your local SSH keys to access GitHub, etc.)
    config.ssh.forward_agent = true

    # Prevent annoying "stdin: is not a tty" errors from displaying during 'vagrant up'
    # See also https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # THIS NEXT PART IS TOTAL HACK (only necessary for running Vagrant on Windows)
    # Windows currently doesn't support SSH Forwarding when running Vagrant's "Provisioning scripts"
    # (e.g. all the "config.vm.provision" commands below). Although running "vagrant ssh" (from Windows commandline)
    # will work for SSH Forwarding once the VM has started up, "config.vm.provision" commands in this Vagrantfile DO NOT.
    # Supposedly there's a bug in 'net-ssh' gem (used by Vagrant) which causes SSH forwarding to fail on Windows only
    # See: https://github.com/mitchellh/vagrant/issues/1735
    #      https://github.com/mitchellh/vagrant/issues/1404
    # See also underlying 'net-ssh' bug: https://github.com/net-ssh/net-ssh/issues/55
    #
    # Therefore, we have to "hack it" and manually sync our SSH keys to the Vagrant VM & copy them over to the 'root' user account
    # (as 'root' is the account that runs all Vagrant "config.vm.provision" scripts below). This all means 'root' should be able
    # to connect to GitHub as YOU! Once this Windows bug is fixed, we should be able to just remove these lines and everything
    # should work via the "config.ssh.forward_agent=true" setting.
    # ONLY do this hack/workaround if the local OS is Windows.
    if Vagrant::Util::Platform.windows?
        # MORE SECURE HACK. You MUST have a ~/.ssh/github_rsa (GitHub specific) SSH key to copy to VM
        # (ensures we are not just copying all your local SSH keys to a VM)
        if File.exists?(File.join(Dir.home, ".ssh", "github_rsa"))
            # Read local machine's GitHub SSH Key (~/.ssh/github_rsa)
            github_ssh_key = File.read(File.join(Dir.home, ".ssh", "github_rsa"))
            # Copy it to VM as the /root/.ssh/id_rsa key
            config.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local GitHub SSH Key to VM for provisioning...' && mkdir -p /root/.ssh && echo '#{github_ssh_key}' > /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa", run: "always"
        else
            # Else, throw a Vagrant Error. Cannot successfully startup on Windows without a GitHub SSH Key!
            raise Vagrant::Errors::VagrantError, "\n\nERROR: GitHub SSH Key not found at ~/.ssh/github_rsa (required for 'vagrant-dspace' on Windows).\nYou can generate this key manually OR by installing GitHub for Windows (http://windows.github.com/)\n\n"
        end
    end

    # Create a '/etc/sudoers.d/root_ssh_agent' file which ensures sudo keeps any SSH_AUTH_SOCK settings
    # This allows sudo commands (like "sudo ssh git@github.com") to have access to local SSH keys (via SSH Forwarding)
    # See: https://github.com/mitchellh/vagrant/issues/1303
    config.vm.provision :shell do |shell|
        shell.inline = "touch $1 && chmod 0440 $1 && echo $2 > $1"
        shell.args = %q{/etc/sudoers.d/root_ssh_agent "Defaults    env_keep += \"SSH_AUTH_SOCK\""}
    end

    # Check if a test SSH connection to GitHub succeeds or fails (on every vagrant up)
    # This sets a Puppet Fact named "github_ssh_status" on the VM.
    # That fact is then used by 'setup.pp' to determine whether to connect to a Git Repo via SSH or HTTPS (see setup.pp)
    config.vm.provision :shell, :inline => "echo 'Testing SSH connection to GitHub on VM...' && mkdir -p /etc/facter/facts.d/ && ssh -T -q -oStrictHostKeyChecking=no git@github.com; echo github_ssh_status=$? > /etc/facter/facts.d/github_ssh.txt", run: "always"


    #------------------------
    # Provisioning Scripts
    #    These scripts run in the order in which they appear, and setup the virtual machine (VM) for us.
    #------------------------

    # Shell script to set up swap space for this VM

    if File.exists?("config/increase-swap.sh")
        config.vm.provision :shell, :inline => "echo '   > > > running local increase-swap.sh to ensure enough memory is available, via a swap file.'"
        config.vm.provision :shell, :path => "config/increase-swap.sh"
    else
        config.vm.provision :shell, :inline => "echo '   > > > running default increase-swap.sh scripte to ensure enough memory is available, via a swap file.'"
        config.vm.provision :shell, :path => "increase-swap.sh"
    end

    # copy the inputrc dotfile to the Vagrant user's home folder, if the config file exists in dotfiles
    if File.exists?("config/dotfiles/inputrc")
        config.vm.provision :shell, :inline => "cp /vagrant/config/dotfiles/inputrc /home/vagrant/.inputrc"
    end

    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    config.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
    config.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys", privileged: false



end
