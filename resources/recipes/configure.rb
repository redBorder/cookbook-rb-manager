#
# Cookbook Name:: manager
# Recipe:: configure
#
# Copyright 2016, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

# Services configuration

# manager services
manager_services = manager_services()

consul_config "Configure Consul Server" do
  confdir node["consul"]["confdir"]
  datadir node["consul"]["datadir"]
  ipaddress node["ipaddress"]
  cdomain node["redborder"]["cdomain"]
  dns_local_ip node["consul"]["dns_local_ip"]
  (manager_services["consul"] ? (is_server true) : (is_server false))
  action ((manager_services["consul"] or manager_services["consul-client"]) ? :add : :remove)
end

if manager_services["chef-server"]
  chef_server_config "Configure chef services" do
    memory node["redborder"]["memory_services"]["chef-server"]["memory"]
    rabbitmq true #TODO: instead of true pass -> manager_services["rabbitmq"] ?
    #TODO: rabbitmq_memory node["redborder"]["memory_services"]["rabbitmq"]["memory"]
    postgresql false
    postgresql_memory node["redborder"]["memory_services"]["postgresql"]["memory"]
    chef_active manager_services["chef-server"]
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
  action (manager_services["zookeeper"] ? [:add, :register] : [:remove, :deregister])
end

kafka_config "Configure Kafka" do
  memory node["redborder"]["memory_services"]["kafka"]["memory"]
  maxsize node["redborder"]["manager"]["hd_services_current"]["kafka"]
  managers_list node["redborder"]["managers_per_services"]["kafka"]
  zk_hosts node["redborder"]["zookeeper"]["zk_hosts"]
  host_index node["redborder"]["kafka"]["host_index"]
  action (manager_services["kafka"] ? [:add, :register] : [:remove, :deregister])
end

if  manager_services["druid-coordinator"] or
    manager_services["druid-overlord"] or
    manager_services["druid-broker"] or
    manager_services["druid-middlemanager"] or
    manager_services["druid-historical"] or
    manager_services["druid-realtime"]

  druid_common "Configure druid common resources" do
    name node["hostname"]
    zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
    memcached_hosts node["redborder"]["memcached"]["hosts"]
    s3_service "s3.service"
    s3_port node["minio"]["port"]
    cdomain node["redborder"]["cdomain"]
    action :add
  end
else
  druid_common "Delete druid common resources" do
    action :remove
  end
end


druid_coordinator "Configure Druid Coordinator" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-coordinator"]["memory"]
  action (manager_services["druid-coordinator"] ? [:add, :register] : [:remove, :deregister])
end

druid_overlord "Configure Druid Overlord" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-overlord"]["memory"]
  action (manager_services["druid-overlord"] ? [:add, :register] : [:remove, :deregister])
end

druid_broker "Configure Druid Broker" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-broker"]["memory"]
  action (manager_services["druid-broker"] ? [:add, :register] : [:remove, :deregister])
end

druid_middlemanager "Configure Druid MiddleManager" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-middlemanager"]["memory"]
  action (manager_services["druid-middlemanager"] ? [:add, :register] : [:remove, :deregister])
end

druid_historical "Configure Druid Historical" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-historical"]["memory"]
  action (manager_services["druid-historical"] ? [:add, :register] : [:remove, :deregister])
end

druid_realtime "Configure Druid Realtime" do
  name node["hostname"]
  memory_kb node["redborder"]["memory_services"]["druid-realtime"]["memory"]
  action (manager_services["druid-realtime"] ? [:add, :register] : [:remove, :deregister])
end

memcached_config "Configure Memcached" do
  memory node["redborder"]["memory_services"]["memcached"]["memory"]
  action (manager_services["memcached"] ? [:add, :register] : [:remove, :deregister])
end

mongodb_config "Configure Mongodb" do
  action (manager_services["mongodb"] ? [:add, :register] : [:remove, :deregister])
end

if manager_services["hadoop-nodemanager"] or
   manager_services["hadoop-resourcemanager"]

  hadoop_common "Configure hadoop common resources" do
    name node["hostname"]
    zookeeper_hosts node["redborder"]["zookeeper"]["zk_hosts"]
    memory_kb node["redborder"]["memory_services"]["hadoop-nodemanager"]["memory"]
    containersMemory node["redborder"]["hadoop"]["containersMemory"]
    action :add
  end
else
  hadoop_common "Delete hadoop common resources" do
    action :remove
  end
end

hadoop_resourcemanager "Configure Hadoop ResourceManager" do
  memory_kb node["redborder"]["memory_services"]["hadoop-resourcemanager"]["memory"]
  action (manager_services["hadoop-resourcemanager"] ? [:add, :register] : [:remove, :deregister])
end

hadoop_nodemanager "Configure Hadoop NodeManager" do
  memory_kb node["redborder"]["memory_services"]["hadoop-nodemanager"]["memory"]
  action (manager_services["hadoop-nodemanager"] ? [:add, :register] : [:remove, :deregister])
end

samza_config "Configure samza applications" do
  memory_per_container node["redborder"]["samza"]["memory_per_container"]
  num_containers node["redborder"]["samza"]["num_containers"]
  action (manager_services["hadoop-nodemanager"] ? :add : :remove)
end

geoip_config "Configure GeoIP" do
  action (manager_services["geoip"] ? :add : :remove)
end

snmp_config "Configure snmp" do
  hostname node["hostname"]
  cdomain node["redborder"]["cdomain"]
  action (manager_services["snmp"] ? :add : :remove)
end

rbmonitor_config "Configure redborder-monitor" do
  name node["hostname"]
  action (manager_services["redborder-monitor"] ? :add : :remove)
end

rbscanner_config "Configure redborder-scanner" do
  scanner_nodes node["redborder"]["sensors_info_all"]["scanner-sensor"]
  action (manager_services["redborder-scanner"] ? [:add, :register] : [:remove, :deregister])
end

nginx_config "Configure Nginx" do
  cdomain node["redborder"]["cdomain"]
  action (manager_services["nginx"] ? [:add, :register] : [:remove, :deregister])
end

webui_config "Configure WebUI" do
  hostname node["hostname"]
  memory_kb node["redborder"]["memory_services"]["webui"]["memory"]
  cdomain node["redborder"]["cdomain"]
  port node["redborder"]["webui"]["port"]
  action (manager_services["webui"] ? [:add, :register, :configure_rsa] : [:remove, :deregister])
  action (manager_services["nginx"] ? [:configure_certs, :add_webui_conf_nginx] : :nothing)
end

http2k_config "Configure Http2k" do
  domain node["redborder"]["cdomain"]
  memory node["redborder"]["memory_services"]["http2k"]["memory"]
  port node["redborder"]["http2k"]["port"]
  proxy_nodes node["redborder"]["sensors_info"]["proxy-sensor"]
  ips_nodes node["redborder"]["sensors_info"]["ips-sensor"]
  ipsg_nodes node["redborder"]["sensors_info"]["ipsg-sensor"]
  organizations node["redborder"]["organizations"]
  locations_list node["redborder"]["locations"]
  action (manager_services["http2k"]  ? [:add, :register] : [:remove, :deregister])
  action (manager_services["nginx"]   ? [:configure_certs, :add_http2k_conf_nginx] : :nothing)
end

ntp_config "Configure NTP" do
  action (manager_services["ntp"] ? :add : :remove)
end

f2k_config "Configure f2k" do
  sensors node["redborder"]["sensors_info"]["flow-sensor"]
  action (manager_services["f2k"] ? [:add, :register] : [:remove, :deregister])
end

pmacct_config "Configure pmacct" do
  sensors node["redborder"]["sensors_info"]["flow-sensor"]
  action (manager_services["pmacct"] ? [:add, :register] : [:remove, :deregister])
end

logstash_config "Configure logstash" do
  cdomain node["redborder"]["cdomain"]
  flow_nodes node["redborder"]["sensors_info_all"]["flow-sensor"]
  namespaces node["redborder"]["namespaces"]
  vault_nodes node["redborder"]["sensors_info_all"]["vault-sensor"]
  scanner_nodes node["redborder"]["sensors_info_all"]["scanner-sensor"]
  action (manager_services["logstash"] ? [:add, :register] : [:remove, :deregister])
end

rbdswatcher_config "Configure redborder-dswatcher" do
  cdomain node["redborder"]["cdomain"]
  action (manager_services["redborder-dswatcher"] ? [:add, :register] : [:remove, :deregister])
end

rbevents_counter_config "Configure redborder-events-counter" do
  cdomain node["redborder"]["cdomain"]
  action (manager_services["redborder-events-counter"] ? [:add, :register] : [:remove, :deregister])
end

rbsocial_config "Configure redborder-social" do
  social_nodes node["redborder"]["sensors_info_all"]["social-sensor"]
  memory node["redborder"]["memory_services"]["redborder-social"]["memory"]
  action (manager_services["redborder-social"] ? [:add, :register] : [:remove, :deregister])
end

rsyslog_config "Configure rsyslog" do
  vault_nodes node["redborder"]["sensors_info_all"]["vault-sensor"] + node["redborder"]["sensors_info_all"]["cep-sensor"]
  ips_nodes node["redborder"]["sensors_info_all"]["ips-sensor"] + node["redborder"]["sensors_info_all"]["ipsv2-sensor"] + node["redborder"]["sensors_info_all"]["ipscp-sensor"]
  action (manager_services["rsyslog"] ? [:add, :register] : [:remove, :deregister])
end

rbnmsp_config "Configure redborder-nmsp" do
  memory node["redborder"]["memory_services"]["redborder-nmsp"]["memory"]
  proxy_nodes node["redborder"]["sensors_info"]["proxy-sensor"]
  flow_nodes node["redborder"]["sensors_info_all"]["flow-sensor"]
  action (manager_services["redborder-nmsp"] ? [:add, :configure_keys, :register] : [:remove, :deregister])
end

n2klocd_config "Configure n2klocd" do
  mse_nodes node["redborder"]["sensors_info_all"]["mse-sensor"]
  meraki_nodes node["redborder"]["sensors_info_all"]["meraki-sensor"]
  n2klocd_managers node["redborder"]["managers_per_services"]["n2klocd"]
  memory node["redborder"]["memory_services"]["n2klocd"]["memory"]
  action (manager_services["n2klocd"] ? [:add, :register] : [:remove, :deregister])
end

rbale_config "Configure redborder-ale" do
  ale_nodes node["redborder"]["sensors_info_all"]["ale-sensor"]
  action (node["redborder"]["services"]["redborder-ale"] ? [:add, :register] : [:remove, :deregister])
end

freeradius_config "Configure radiusd" do
  flow_nodes node["redborder"]["sensors_info_all"]["flow-sensor"]
  action (node["redborder"]["services"]["radiusd"] ? [:add, :register] : [:remove, :deregister])
end

rbcep_config "Configure redborder-cep" do
  flow_nodes node["redborder"]["sensors_info_all"]["flow-sensor"]
  social_nodes node["redborder"]["sensors_info_all"]["social-sensor"]
  vault_nodes node["redborder"]["sensors_info_all"]["vault-sensor"]
  ips_nodes node["redborder"]["sensors_info_all"]["ips-sensor"] + node["redborder"]["sensors_info_all"]["ipsv2-sensor"] + node["redborder"]["sensors_info_all"]["ipscp-sensor"]
  action (node["redborder"]["services"]["redborder-cep"] ? [:add, :register] : [:remove, :deregister])
end

# Determine external
external_services = Chef::DataBagItem.load("rBglobal", "external_services")

postgresql_config "Configure postgresql" do
  cdomain node["redborder"]["cdomain"]
  action (manager_services["postgresql"] and external_services["postgresql"] == "onpremise" ? [:add, :register] : [:remove, :deregister])
end

s3_leader = `serf members | grep s3=ready | awk '{print $1'} | head -n 1`.strip

# Allow only one s3 onpremise node for now.. TODO: Distributed MinIO
minio_config "Configure S3 (minio)" do
  action ((manager_services["s3"] and external_services["s3"] == "onpremise" and s3_leader == node.name ) ? [:add, :register] : [:remove, :deregister])
end

if manager_services["s3"]
  nginx_config "Configure S3 certs" do
    service_name "s3"
    cdomain node["redborder"]["cdomain"]
    action :configure_certs
  end
end

ssh_secrets = Chef::DataBagItem.load("passwords", "ssh") rescue ssh_secrets = {}

directory "/root/.ssh" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

if !ssh_secrets.empty?
  template "/root/.ssh/authorized_keys" do
    source "rsa.pub.erb"
    owner "root"
    group "root"
    mode 0600
    retries 2
    variables(:public_rsa => ssh_secrets['public_rsa'])
  end
end
