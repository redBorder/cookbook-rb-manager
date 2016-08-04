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

druid_coordinator "Configure Druid Coordinator" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid_coordinator"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  psql_user "druid"
  psql_password "druid"
  psql_uri "jdbc:postgresql://localhost:5432/druid"
  action (node["redborder"]["services"]["druid-coordinator"] ? :add : :remove)
end

druid_overlord "Configure Druid Overlord" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid_overlord"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  psql_user "druid"
  psql_password "druid"
  psql_uri "jdbc:postgresql://localhost:5432/druid"
  action (node["redborder"]["services"]["druid-overlord"] ? :add : :remove)
end

druid_broker "Configure Druid Broker" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid_broker"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  psql_user "druid"
  psql_password "druid"
  psql_uri "jdbc:postgresql://localhost:5432/druid"
  action (node["redborder"]["services"]["druid-broker"] ? :add : :remove)
end

druid_middlemanager "Configure Druid MiddleManager" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid_middlemanager"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  psql_user "druid"
  psql_password "druid"
  psql_uri "jdbc:postgresql://localhost:5432/druid"
  action (node["redborder"]["services"]["druid-middlemanager"] ? :add : :remove)
end

druid_historical "Configure Druid Historical" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid_historical"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  psql_user "druid"
  psql_password "druid"
  psql_uri "jdbc:postgresql://localhost:5432/druid"
  action (node["redborder"]["services"]["druid-historical"] ? :add : :remove)
end

http2k_config "Configure Http2k" do
  domain node["redborder"]["cdomain"]
  memory node["redborder"]["memory_services"]["http2k"]["memory"]
  port node["redborder"]["http2k"]["port"]
  hosts node["redborder"]["managers_per_services"]["http2k"]
  kafka_hosts node["redborder"]["managers_per_services"]["kafka"]
  proxy_nodes node["redborder"]["sensors_info"]["proxy-sensor"] 
  ips_nodes node["redborder"]["sensors_info"]["ips-sensor"] 
  ipsg_nodes node["redborder"]["sensors_info"]["ipsg-sensor"]
  organizations node["redborder"]["organizations"]
  locations_list node["redborder"]["locations"]
  action (node["redborder"]["services"]["http2k"] ? :add : :remove)
end

