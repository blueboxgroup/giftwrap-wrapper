# encoding: UTF-8

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.box_url = ''

  config.vm.provision 'shell', inline: <<-EOF
    curl -sSL get.docker.com | bash
    usermod -aG docker vagrant
  EOF

  config.vm.define 'giftwrapper' do |c|
    c.vm.host_name = 'giftwrapper'
  end
end
