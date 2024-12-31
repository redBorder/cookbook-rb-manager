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

template '/etc/logrotate.d/logstash' do
  source 'logstash_log-rotate.erb'
  owner 'root'
  group 'root'
  mode 0644
  retries 2
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

node.run_state['organizations'] = get_orgs if node['redborder']['services']['http2k']

if node['redborder']['services']['logstash']
  node.run_state['pipelines'] = get_pipelines
  node.run_state['flow_sensors_info'] = get_all_flow_sensors_info['flow-sensor']
end

# get elasticache nodes
begin
  elasticache = data_bag_item('rBglobal', 'elasticache')
rescue
  elasticache = {}
end

if !elasticache.empty? && !elasticache['cfg_address'].nil? && !elasticache['cfg_address'].emtpy? && !elasticache['cfg_port'].nil? && !elasticache['cfg_port'].emtpy?
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

# get sensors info (skipping childs of proxy sensors)
node.run_state['sensors_info'] = get_sensors_info

# get sensors info full info of all sensors
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

erchef_hosts = node['redborder']['managers_per_services']['chef-server'].map { |z| "#{z}.#{node['redborder']['cdomain']}" if node['redborder']['cdomain'] }
node.default['redborder']['erchef']['hosts'] = erchef_hosts

http2k_hosts = node['redborder']['managers_per_services']['http2k'].map { |z| "#{z}.#{node['redborder']['cdomain']}" if node['redborder']['cdomain'] }
node.default['redborder']['http2k']['hosts'] = http2k_hosts

rb_aioutliers_hosts = node['redborder']['managers_per_services']['rb-aioutliers'].map { |z| "#{z}.#{node['redborder']['cdomain']}" if node['redborder']['cdomain'] }
node.default['redborder']['rb-aioutliers']['hosts'] = rb_aioutliers_hosts

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

# Build service list for rbcli
services = node['redborder']['services'] || []
systemd_services = node['redborder']['systemdservices'] || []
service_enablement = {}

systemd_services.each do |service_name, systemd_name|
  service_enablement[systemd_name.first] = services[service_name]
end

Chef::Log.info('Saving services enablement into /etc/redborder/services.json')
File.write('/etc/redborder/services.json', JSON.pretty_generate(service_enablement))
