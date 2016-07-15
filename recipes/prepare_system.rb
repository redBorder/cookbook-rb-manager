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

#get an array of managers
managers_list = []
node["redborder"]["cluster_info"].each_key do |mgr|
  managers_list << mgr
end
node.default["redborder"]["managers_list"] = managers_list

# get managers with zookeeper
managers_with_zookeeper = []
node["redborder"]["cluster_info"].each do |mgr, m_val|
  managers_with_zookeeper << mgr if m_val["services"].to_a.include?("zookeeper")
end
node.default["redborder"]["zookeeper_hosts"] = managers_with_zookeeper

#hard disk
node.default["redBorder"]["manager"]["hd_services_current"] = harddisk_services()

#node.set["redborder"]["memory"] = memory(12345678)

# create /etc/hosts
template "/etc/hosts" do
  source "etc_hosts.erb"
  variables(:cluster_info => node["redborder"]["cluster_info"]) 
  mode "0644"
end

