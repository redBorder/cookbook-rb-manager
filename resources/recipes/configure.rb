#
# Cookbook Name:: manager
# Recipe:: configure
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

# Services configuration

consul_config "Configure Consul Server" do
  confdir node["consul"]["confdir"]
  datadir node["consul"]["datadir"]
  ipaddress node["ipaddress"]
  cdomain node["redborder"]["cdomain"]
  dns_local_ip node["consul"]["dns_local_ip"]
  (node["redborder"]["services"]["consul"] ? (is_server true) : (is_server false))
  action ((node["redborder"]["services"]["consul"] or node["redborder"]["services"]["consul-client"]) ? :add : :remove)
end

if node["redborder"]["services"]["chef-server"] or node["redborder"]["services"]["postgresql"]
  chef_server_config "Configure chef services" do
    memory node["redborder"]["memory_services"]["chef-server"]["memory"]
    postgresql node["redborder"]["services"]["postgresql"]
    postgresql_memory node["redborder"]["memory_services"]["postgresql"]["memory"]
    chef_active node["redborder"]["services"]["chef-server"]
    action [:add, :register]
  end
else
  chef_server_config "Remove chef service" do
    action [:remove, :deregister]
  end
end

zookeeper_config "Configure Zookeeper" do
  port node["zookeeper"]["port"]
  memory node["redborder"]["memory_services"]["zookeeper"]["memory"]
  hosts node["redborder"]["managers_per_services"]["zookeeper"]
  action (node["redborder"]["services"]["zookeeper"] ? [:add, :register] : [:remove, :deregister])
end

kafka_config "Configure Kafka" do
  memory node["redborder"]["memory_services"]["kafka"]["memory"]
  maxsize node["redborder"]["manager"]["hd_services_current"]["kafka"]
  managers_list node["redborder"]["managers_per_services"]["kafka"]
  zk_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  host_index node["redborder"]["kafka"]["host_index"]
  action (node["redborder"]["services"]["kafka"] ? [:add, :register] : [:remove, :deregister])
end

druid_coordinator "Configure Druid Coordinator" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-coordinator"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  action (node["redborder"]["services"]["druid-coordinator"] ? [:add, :register] : [:remove, :deregister])
end

druid_overlord "Configure Druid Overlord" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-overlord"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  action (node["redborder"]["services"]["druid-overlord"] ? [:add, :register] : [:remove, :deregister])
end

druid_broker "Configure Druid Broker" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-broker"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  action (node["redborder"]["services"]["druid-broker"] ? [:add, :register] : [:remove, :deregister])
end

druid_middlemanager "Configure Druid MiddleManager" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-middlemanager"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  action (node["redborder"]["services"]["druid-middlemanager"] ? [:add, :register] : [:remove, :deregister])
end

druid_historical "Configure Druid Historical" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-historical"]["memory"]
  zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  action (node["redborder"]["services"]["druid-historical"] ? [:add, :register] : [:remove, :deregister])
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

memcached_config "Configure Memcached" do
  memory node["redborder"]["memory_services"]["memcached"]["memory"]
  port node["redborder"]["memcached"]["port"]
  maxconn node["redborder"]["memcached"]["maxconn"]
  cachesize node["redborder"]["memcached"]["cachesize"]
  options node["redborder"]["memcached"]["options"]
  action (node["redborder"]["services"]["memcached"] ? :add : :remove)
end