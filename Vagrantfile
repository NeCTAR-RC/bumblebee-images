Vagrant.configure("2") do |config|

  # Generic Ubuntu 20.04 (focal)
  config.vm.define "ubuntu-2004" do |c|
    c.vm.box = "generic/ubuntu2004"
    c.vm.provider "virtualbox" do |v, override|
      override.vm.box = "ubuntu/focal64"
    end
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true,
                             ansible_python_interpreter: "/usr/bin/python3" }
      ansible.playbook = "ansible/playbook-xfce4.yml"
      ansible.become = true
    end
  end

  # Generic CentOS 7
  config.vm.define "centos-7" do |c|
    c.vm.box = "centos/7"
      c.vm.provision "shell" do |shell|
        # Our official images have epel pre-installed
        shell.inline = "sudo yum -y -q install epel-release"
      end

    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true }
      ansible.playbook = "ansible/playbook-mate.yml"
      ansible.become = true
    end
  end

  # Fedora Scientific
  config.vm.define "fedora-scientific" do |c|
    c.vm.box = "fedora/35-cloud-base"
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true }
      ansible.playbook = "ansible/playbook-fedora-scientific.yml"
      ansible.become = true
    end
  end

  # NeuroDesk
  config.vm.define "neurodesk" do |c|
    c.vm.box = "generic/ubuntu2004"
    c.vm.provider "virtualbox" do |v, override|
      override.vm.box = "ubuntu/focal64"
    end
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true,
                             ansible_python_interpreter: "/usr/bin/python3" }
      ansible.playbook = "ansible/playbook-neurodesk.yml"
      ansible.become = true
    end
  end

  # Geodesktop
  config.vm.define "geodesktop" do |c|
    c.vm.box = "generic/ubuntu2004"
    c.vm.provider "virtualbox" do |v, override|
      override.vm.box = "ubuntu/focal64"
    end
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true,
                             ansible_python_interpreter: "/usr/bin/python3" }
      ansible.playbook = "ansible/playbook-geodesktop.yml"
      ansible.become = true
    end
  end

  # Bumblebee Guacamole Server
  config.vm.define "guacamole" do |c|
    c.vm.box = "generic/ubuntu2004"
    c.vm.provider "virtualbox" do |v, override|
      override.vm.box = "ubuntu/focal64"
    end
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true,
                             ansible_python_interpreter: "/usr/bin/python3" }
      ansible.playbook = "ansible/playbook-guacamole.yml"
      ansible.become = true
    end
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network :forwarded_port, guest: 3389, host: 3389, host_ip: '0.0.0.0'
  config.vm.network :forwarded_port, guest: 8080, host: 8080, host_ip: '0.0.0.0'
  config.vm.provider :libvirt do |v|
    v.memory = 4096
    v.cpus = 4
  end
  config.vm.provider :virtualbox do |v|
    v.memory = 2048
    v.cpus = 2
    # Fix for ubuntu images hanging https://bugs.launchpad.net/cloud-images/+bug/1829625
    v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
    v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
  end

end
