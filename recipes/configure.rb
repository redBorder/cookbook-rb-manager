#
# Cookbook Name:: manager
# Recipe:: configure
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

zookeeper_config "Configure Zookeeper" do
  memory 524288
  hosts node["redborder"]["zookeeper_hosts"]
  action (node["redborder"]["services"]["zookeeper"] ? :add : :remove)
end

kafka_config "Configure Kafka" do
  memory 524288
  maxsize node["redBorder"]["manager"]["hd_services_current"]["kafka"]
  managers_list  ["localhost"]
  action :add
end

#zookeeper_zk2_config "Configure Zookeeper 2" do
#  memory node["redborder"]["memory"]
#  managers node["redborder"]["managers"]
#  action :add
#end

