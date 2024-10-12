# Cookbook:: manager
# Recipe:: prepare_system
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

extend RbManager::Helpers

# clean metadata to get packages upgrades
execute 'Clean yum metadata' do
  command 'yum clean metadata'
end

# Set services_group related with the node mode (core, full, ...)
node['redborder']['services_group'][node['redborder']['mode']].each { |s| node.default['redborder']['services'][s] = true }

node.default['redborder']['services']['consul-client'] = (node['redborder']['mode'] != 'core' && node['redborder']['mode'] != 'full')

node.run_state['cluster_installed'] = File.exist?('/etc/redborder/cluster-installed.txt')

# Set :ipaddress_sync
ipaddress_sync = node['ipaddress']
sync_net = `cat /etc/redborder/rb_init_conf.yml  | grep sync_net | awk '{print $2'} | sed 's|/.*||'`.strip

node['network']['interfaces'].each do |interface, _details|
  next unless "x#{interface}" != 'xlo'

  # ipaddress_sync = `ip route get #{sync_net} | head -n 1 | awk '{for (i=1; i<=NF; i++) if ($i == 'src') print $(i+1)}'`.strip
  ipaddress_sync = `ip route get #{sync_net} | head -n 1 | awk '/src/ {print $5}'`.strip
end

node.default[:ipaddress_sync] = ipaddress_sync

# Opens the kafka port for the IP of the IPS if in manager/ssh mode.
# If the manager has 2 or more interfaces.
open_ports_for_ips if ipaddress_sync != node['ip_address']

# get mac
mac_sync = `ip a | grep -w -B2 #{ipaddress_sync} | awk '{print toupper($2)}' | head -n 1 | tr -d '\n'`
node.default['mac_sync'] = mac_sync

# Configure and enable chef-client
dnf_package 'redborder-chef-client' do
  flush_cache [:before]
  action :upgrade
end

template '/etc/sysconfig/chef-client' do
  source 'sysconfig_chef-client.rb.erb'
  mode '0644'
  variables(interval: node['chef-client']['interval'],
            splay: node['chef-client']['splay'],
            options: node['chef-client']['options'])
end

service 'chef-client' do
  if node['redborder']['services']['chef-client'] && node.run_state['cluster_installed']
    action [:enable, :start]
  else
    action [:stop]
  end
end

# get cluster domain
node.default['redborder']['cdomain'] = File.read('/etc/redborder/cdomain').chomp

# get managers information(name, ip, services...)
node.default['redborder']['cluster_info'] = get_cluster_info

# manager services
node.run_state['manager_services'] = manager_services
node.default['redborder']['manager']['services']['current'] = node.run_state['manager_services']

# get managers sorted by service
node.default['redborder']['managers_per_services'] = managers_per_service

# get elasticache nodes
begin
  elasticache = data_bag_item('rBglobal', 'elasticache')
rescue
  elasticache = {}
end

if !elasticache.empty?
  node.default['redborder']['memcached']['server_list'] = getElasticacheNodes(elasticache['cfg_address'], elasticache['cfg_port'])
  node.default['redborder']['memcached']['port'] = elasticache['cfg_port']
  node.default['redborder']['memcached']['hosts'] = joinHostArray2port(node['redborder']['memcached']['server_list'], node['redborder']['memcached']['port']).join(',')
  node.default['redborder']['memcached']['elasticache'] = true
else
  memcached_hosts = []
  managers_per_service['memcached'].uniq.each do |m|
    memcached_hosts << "#{m}.node:#{node['redborder']['memcached']['port']}"
  end
  node.default['redborder']['memcached']['hosts'] = memcached_hosts
end

# get sensors info
node.run_state['sensors_info'] = get_sensors_info

# get sensors info full info
node.run_state['sensors_info_all'] = get_sensors_all_info

# get namespaces
node.run_state['namespaces'] = get_namespaces

node.run_state['managers'] = get_managers_all

# keepalived
# Update keepalived status
node.run_state['has_balanced_service_enable'] = false
if node.run_state['manager_services']['keepalived']
  node.run_state['has_balanced_service_enable'] = true
else
  unless node['redborder']['manager']['balanced'].nil?
    node['redborder']['manager']['balanced'].each do |s|
      node.run_state['has_balanced_service_enable'] = true if node.run_state['manager_services'][s[:service]]
    end
  end
end
node.run_state['virtual_ips'], node.run_state['has_any_virtual_ip'] = get_virtual_ip_info(node.run_state['managers'])
node.run_state['virtual_ips_per_ip'] = get_virtual_ips_per_ip_info(node.run_state['virtual_ips'])
if File.exist?'/etc/lock/keepalived'
  node.run_state['manager_services']['keepalived'] = false
elsif node['redborder'].nil? || node['redborder']['dmidecode'].nil? || node['redborder']['dmidecode']['manufacturer'].nil? || node['redborder']['dmidecode']['manufacturer'].to_s.downcase == 'xen'
  if manager_index > 0 && !node.run_state['cluster_installed']
    node.run_state['manager_services']['keepalived'] = false
  else
    node.run_state['manager_services']['keepalived'] = node.run_state['has_any_virtual_ip'] and !File.exist?'/etc/lock/keepalived'
  end
else
  node.run_state['manager_services']['keepalived'] = node.run_state['has_any_virtual_ip'] and !File.exist?'/etc/lock/keepalived'
end

# get string with all zookeeper hosts and port separated by commas, its needed for multiples services
node.default['redborder']['zookeeper']['zk_hosts'] = "zookeeper.service.#{node['redborder']['cdomain']}:#{node['redborder']['zookeeper']['port']}"

# set webui hosts
webui_hosts = node['redborder']['managers_per_services']['webui'].map { |z| "#{z}.#{node['redborder']['cdomain']}" if node['redborder']['cdomain'] }
node.default['redborder']['webui']['hosts'] = webui_hosts
node.run_state['auth_token'] = get_api_auth_token if File.exist?('/etc/redborder/cluster-installed.txt')

# set kafka host index if kafka is enabled in this host
if node['redborder']['managers_per_services']['kafka'].include?(node.name)
  node.default['redborder']['kafka']['host_index'] = node['redborder']['managers_per_services']['kafka'].index(node.name)
end

# Set all nodes with s3 configured (nginx load balancer)
s3_hosts = node['redborder']['managers_per_services']['s3'].map { |z| "#{z}.#{node['redborder']['cdomain']}:9000" if node['redborder']['cdomain'] }
node.default['redborder']['s3']['s3_hosts'] = s3_hosts

# set druid realtime partition id (its needed in cluster mode for druid brokers)
if node['redborder']['managers_per_services']['druid-realtime'].include?(node.name)
  node.default['redborder']['druid']['realtime']['partition_num'] = node['redborder']['managers_per_services']['druid-realtime'].index(node.name)
end

# get an array of managers
managers_list = []
node['redborder']['cluster_info'].each_key { |mgr| managers_list << mgr }
node.default['redborder']['managers_list'] = managers_list

# hard disk
node.default['redborder']['manager']['hd_services_current'] = harddisk_services()

# memory
# getting total system memory less 10% reserved by system
sysmem_total = (node['memory']['total'].to_i * 0.90).to_i
# node attributes related with memory are changed inside the function to have simplicity using recursivity
memory_services(sysmem_total)

# License
modules = %w(ips flow monitor location api malware vault)

fmodules = []

modules.each do |x|
  if node['redborder'] && node['redborder']['manager'] && node['redborder']['manager']['modules'] && node['redborder']['manager']['modules'][x]
    fmodules << x if node['redborder']['manager']['modules'][x]
  else
    fmodules << x
  end
end

node.normal['redborder']['license']['fmodules'] = fmodules

# For each node add <node ip> <hostname>.<domain> to /etc/hosts
hosts_entries = node.run_state['managers'].map do |m|
  if m['ipaddress_sync'] && m['name'] && node['redborder']['cdomain']
    "#{m['ipaddress_sync']} #{m['name']}.#{node['redborder']['cdomain']}"
  end
end

hosts_entries.each do |line|
  execute "Add #{line} to /etc/hosts" do
    command "echo '#{line}' >> /etc/hosts"
    not_if "grep -q '^#{line}' /etc/hosts"
  end
end
