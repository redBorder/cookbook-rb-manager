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
mode = node['redborder']['mode']
node['redborder']['services_group'][mode].each { |s| node.default['redborder']['services'][s] = true }

if mode != 'core' || mode != 'full'
  node.default['redborder']['services']['consul-client'] = true
end

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

service 'chef-client' do
  if node['redborder']['services']['chef-client']
    action [:enable, :start]
  else
    action [:stop]
  end
end

# get managers information(name, ip, services...)
cdomain = ''
File.open('/etc/redborder/cdomain') { |f| cdomain = f.readline.chomp }
node.default['redborder']['cdomain'] = cdomain

# get managers information(name, ip, services...)
node.default['redborder']['cluster_info'] = get_cluster_info()

# get managers sorted by service
node.default['redborder']['managers_per_services'] = managers_per_service()

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
  node.default['redborder']['memcached']['hosts'] = "memcached.service.#{node['redborder']['cdomain']}:#{node['redborder']['memcached']['port']}"
end

# get organizations for http2k
node.default['redborder']['organizations'] = get_orgs() if node['redborder']['services']['http2k']

# get sensors info
node.run_state['sensors_info'] = get_sensors_info()

# get sensors info full info
node.run_state['sensors_info_all'] = get_sensors_all_info()

# get sensors info of all flow sensors
node.run_state['all_flow_sensors_info'] = get_all_flow_sensors_info()

# get logstash pipelines
node.run_state['pipelines'] = get_pipelines()

# get namespaces
node.run_state['namespaces'] = get_namespaces

# get string with all zookeeper hosts and port separated by commas, its needed for multiples services
# zk_port = node['redborder']['zookeeper']['port']
# zk_hosts = node['redborder']['managers_per_services']['zookeeper'].map {|z| '#{z}.node:#{zk_port}'}.join(',')
node.default['redborder']['zookeeper']['zk_hosts'] = "zookeeper.service.#{node['redborder']['cdomain']}:#{node['redborder']['zookeeper']['port']}"

# set webui hosts
webui_hosts = node["redborder"]["managers_per_services"]["webui"].map {|z| "#{z}.node"}
node.default["redborder"]["webui"]["hosts"] = webui_hosts

#set kafka host index if kafka is enabled in this host
if node["redborder"]["managers_per_services"]["kafka"].include?(node.name)
  node.default["redborder"]["kafka"]["host_index"] = node["redborder"]["managers_per_services"]["kafka"].index(node.name)
end

# Set all nodes with s3 configured (nginx load balancer)
s3_hosts = node['redborder']['managers_per_services']['s3'].map { |z| "#{z}.node:9000" }
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
