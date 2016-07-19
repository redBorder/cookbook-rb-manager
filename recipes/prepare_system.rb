#
# Cookbook Name:: manager
# Recipe:: prepare_system
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#
extend Rb_manager::Helpers

# get managers information(name, ip, services...)
node.default["redborder"]["cluster_info"] = get_cluster_info()

#get managers sorted by service
node.default["redborder"]["managers_per_services"] = managers_per_service()

#get string with all zookeeper hosts and port separated by commas, its needed for multiples services
zk_port = node["redborder"]["zookeeper"]["port"] 
zk_hosts = node["redborder"]["managers_per_services"]["zookeeper"].map {|z| "#{z}:#{zk_port}"}.join(',') 
node.default["redborder"]["zookeeper"]["zk_hosts"] = zk_hosts

#set kafka host index if kafka is enabled in this host
if node["redborder"]["managers_per_services"]["kafka"].include?(node.name)
  node.default["redborder"]["kafka"]["host_index"] = node["redborder"]["managers_per_services"]["kafka"].index(node.name) 
end

#get an array of managers
managers_list = []
node["redborder"]["cluster_info"].each_key do |mgr|
  managers_list << mgr
end
node.default["redborder"]["managers_list"] = managers_list

#hard disk
node.default["redBorder"]["manager"]["hd_services_current"] = harddisk_services()

#node.set["redborder"]["memory"] = memory(12345678)

# create /etc/hosts
template "/etc/hosts" do
  source "etc_hosts.erb"
  variables(:cluster_info => node["redborder"]["cluster_info"]) 
  mode "0644"
end

