#
# Cookbook Name:: manager
# Recipe:: prepare_system
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#
extend Rb_manager::Helpers

node.default["redborder"]["managers_info"] = get_managers_info()

managers_list = []

node["redborder"]["managers_info"].each_key do |mgr|
  managers_list << mgr
end
node.default["redborder"]["managers_list"] = managers_list

##node.set["redborder"]["memory"] = memory(12345678)


# create /etc/hosts
template "/etc/hosts" do
  source "etc_hosts.erb"
  variables(:managers_info => node["redborder"]["managers_info"]) 
  mode "0644"
end

