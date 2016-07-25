#
# Cookbook Name:: manager
# Recipe:: configure
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

zookeeper_config "Configure Zookeeper" do
  port node["zookeeper"]["port"] 
  memory node["redborder"]["memory_services"]["zookeeper"]["memory"]
  hosts node["redborder"]["managers_per_services"]["zookeeper"]
  action (node["redborder"]["services"]["zookeeper"] ? :add : :remove)
end

kafka_config "Configure Kafka" do
  memory node["redborder"]["memory_services"]["kafka"]["memory"]
  maxsize node["redborder"]["manager"]["hd_services_current"]["kafka"]
  managers_list node["redborder"]["managers_per_services"]["kafka"]
  zk_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  host_index node["redborder"]["kafka"]["host_index"]
  action (node["redborder"]["services"]["kafka"] ? :add : :remove)
end

