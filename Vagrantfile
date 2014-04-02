# -*- mode: ruby -*-
# vi: set ft=ruby :

map = {
  'fedora' => 'todo', # Fedora 20
  'rhel' => 'todo', # CentOS/RHEL 6.5
  'centos' => 'todo',
  'ubuntu' => 'hashicorp/precise64'
}

box = map[(ENV['DISTRO'] || 'ubuntu').downcase]

Vagrant.configure("2") do |config|
  config.vm.box = box

  vm_name = "#{box.split(/\//)[1]}"
  config.vm.define vm_name do |c|
    c.vm.host_name = vm_name
    c.vm.network 'private_network', ip: '192.168.50.11' # eth1
  end

  config.vm.provider 'virtualbox' do |p|
    p.customize ['modifyvm', :id, '--memory', '2048']
  end

  #config.vm.provision 'shell', inline: 'apt-get update; apt-get upgrade --yes'
  #config.vm.provision 'shell', :path => 'vagrant.sh'
end
