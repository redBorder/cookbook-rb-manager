#
# Cookbook Name:: manager
# Recipe:: prepare_system
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#
extend Rb_manager::Helpers

#clean metadata to get packages upgrades
execute "Clean yum metadata" do
  command "yum clean metadata"
end

# Set services_group related with the node mode (core, full, ...)
mode = node["redborder"]["mode"]
node["redborder"]["services_group"][mode].each do |s|
  node.default["redborder"]["services"][s] = true
end
if mode != "core" or mode != "full"
 node.default["redborder"]["services"]["consul-client"] = true
end

#Set :ipaddress_sync
ipaddress_sync=node["ipaddress"]
sync_net = `cat /etc/redborder/rb_init_conf.yml  | grep sync_net | awk '{print $2'} | sed 's|/.*||'`.strip
node['network']['interfaces'].each do |interface, details|
  next unless "x#{interface}" != "xlo"
  ipaddress_sync = `ip route get #{sync_net} | head -n 1 | awk '{for (i=1; i<=NF; i++) if ($i == "src") print $(i+1)}'`.strip
end
node.default[:ipaddress_sync]=ipaddress_sync

#get mac
mac_sync = `ip a | grep -w -B2 #{ipaddress_sync} | awk '{print toupper($2)}' | head -n 1 | tr -d '\n'`
node.default["mac_sync"] = mac_sync

#Configure and enable chef-client
dnf_package "redborder-chef-client" do
  flush_cache [:before]
  action :upgrade
end

template "/etc/sysconfig/chef-client" do
  source "sysconfig_chef-client.rb"
  mode 0644
  variables(
    :interval => node["chef-client"]["interval"],
    :splay => node["chef-client"]["splay"],
    :options => node["chef-client"]["options"]
  )
end

if node["redborder"]["services"]["chef-client"]
  service "chef-client" do
    action [:enable, :start]
  end
else
  service "chef-client" do
    action [:stop]
  end
end

#get managers information(name, ip, services...)
cdomain = ""
File.open('/etc/redborder/cdomain') {|f| cdomain = f.readline.chomp}
node.default["redborder"]["cdomain"] = cdomain

#get managers information(name, ip, services...)
node.default["redborder"]["cluster_info"] = get_cluster_info()

#get managers sorted by service
node.default["redborder"]["managers_per_services"] = managers_per_service()

#get elasticache nodes
elasticache = Chef::DataBagItem.load("rBglobal", "elasticache") rescue elasticache = {}
if !elasticache.empty?
  node.default["redborder"]["memcached"]["server_list"] = getElasticacheNodes(elasticache["cfg_address"], elasticache["cfg_port"])
  node.default["redborder"]["memcached"]["port"] = elasticache["cfg_port"]
  node.default["redborder"]["memcached"]["hosts"] = joinHostArray2port(node["redborder"]["memcached"]["server_list"], node["redborder"]["memcached"]["port"]).join(",")
  node.default["redborder"]["memcached"]["elasticache"] = true
else
  node.default["redborder"]["memcached"]["hosts"] = "memcached.service.#{node["redborder"]["cdomain"]}:#{node["redborder"]["memcached"]["port"]}"
end

#get organizations for http2k
node.default["redborder"]["organizations"] = get_orgs() if node["redborder"]["services"]["http2k"]

#get sensors info
node.default["redborder"]["sensors_info"] = get_sensors_info()

#get sensors info full info
node.default["redborder"]["sensors_info_all"] = get_sensors_all_info()

#get sensors info of all flow sensors
node.default["redborder"]["all_flow_sensors_info"] = get_all_flow_sensors_info()

#get logstash pipelines
node.default["redborder"]["logstash"]["pipelines"] = get_pipelines()

#get namespaces
node.default["redborder"]["namespaces"] = get_namespaces

#get string with all zookeeper hosts and port separated by commas, its needed for multiples services
zk_port = node["redborder"]["zookeeper"]["port"]
#zk_hosts = node["redborder"]["managers_per_services"]["zookeeper"].map {|z| "#{z}.node:#{zk_port}"}.join(',')
node.default["redborder"]["zookeeper"]["zk_hosts"] = "zookeeper.service.#{node["redborder"]["cdomain"]}:#{node["redborder"]["zookeeper"]["port"]}"

#set kafka host index if kafka is enabled in this host
if node["redborder"]["managers_per_services"]["kafka"].include?(node.name)
  node.default["redborder"]["kafka"]["host_index"] = node["redborder"]["managers_per_services"]["kafka"].index(node.name)
end

#set druid realtime partition id (its needed in cluster mode for druid brokers)
if node["redborder"]["managers_per_services"]["druid-realtime"].include?(node.name)
  node.default["redborder"]["druid"]["realtime"]["partition_num"] = node["redborder"]["managers_per_services"]["druid-realtime"].index(node.name)
end

#get an array of managers
managers_list = []
node["redborder"]["cluster_info"].each_key do |mgr|
  managers_list << mgr
end
node.default["redborder"]["managers_list"] = managers_list

#hard disk
node.default["redborder"]["manager"]["hd_services_current"] = harddisk_services()

#memory
#getting total system memory less 10% reserved by system
sysmem_total = (node["memory"]["total"].to_i * 0.90).to_i
#node attributes related with memory are changed inside the function to have simplicity using recursivity
memory_services(sysmem_total, node['redborder']['excluded_memservices'])

#License

modules = ["ips", "flow", "monitor", "location", "api", "malware", "vault"]

fmodules = []

modules.each do |x|
  if !node["redborder"].nil? and !node["redborder"]["manager"].nil? and !node["redborder"]["manager"]["modules"].nil? and !node["redborder"]["manager"]["modules"][x].nil?
    fmodules << x if node["redborder"]["manager"]["modules"][x]
  else
    fmodules << x
  end
end

node.normal["redborder"]["license"]["fmodules"] = fmodules
