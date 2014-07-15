map = {
  'ubuntu' => 'hashicorp/precise64',
  'cpu' => '2',
  'memory' => '2048'
}

box = map[(ENV['DISTRO'] || 'ubuntu').downcase]

Vagrant.configure('2') do |config|
  config.vm.box = box

  vm_name = "#{box.split(/\//)[1]}"
  config.vm.define vm_name do |c|
    c.vm.host_name = vm_name
    c.vm.network 'private_network', ip: '192.168.50.11' # eth1
  end

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--cpus', map['cpu']]
    v.customize ['modifyvm', :id, '--memory', map['memory']]
  end

  config.vm.provider 'vmware_fusion' do |v|
    v.vmx['numvcpus'] = map['cpu']
    v.vmx['memsize'] = map['memory']
  end
end
