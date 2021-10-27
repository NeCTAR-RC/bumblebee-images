Vagrant.configure("2") do |config|

  # Generic Ubuntu 20.04 (focal)
  config.vm.define "ubuntu2004" do |c|
    c.vm.box = "generic/ubuntu2004"
    c.vm.provider "virtualbox" do |v, override|
      override.vm.box = "ubuntu/focal64"
    end
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true,
                             ansible_python_interpreter: "/usr/bin/python3" }
      ansible.playbook = "ansible/playbook.yml"
      ansible.become = true
    end
  end

  # Generic CentOS 7
  config.vm.define "centos7" do |c|
    c.vm.box = "centos/7"
    c.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = { nectar_test_build: true }
      ansible.playbook = "ansible/playbook.yml"
      ansible.become = true
    end
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network :forwarded_port, guest: 3389, host: 3389, host_ip: '0.0.0.0'
  config.vm.provider :libvirt do |v|
    v.memory = 2048
    v.cpus = 2
  end
  config.vm.provider :virtualbox do |v|
    v.memory = 2048
    v.cpus = 2
    # Fix for ubuntu images hanging https://bugs.launchpad.net/cloud-images/+bug/1829625
    v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
    v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
  end

end
