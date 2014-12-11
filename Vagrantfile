# encoding: UTF-8

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.provision 'shell', inline: <<-EOF
    curl -sSL get.docker.com | bash
    usermod -aG docker vagrant
  EOF

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define 'giftwrapper' do |c|
    c.vm.host_name = 'giftwrapper'
  end
end
