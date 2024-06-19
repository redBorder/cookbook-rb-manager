# Cookbook:: manager
# Recipe:: configure
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

# Services configuration

# manager services
managers = node.run_state['managers']
manager_services = node.run_state['manager_services']
node.default['redborder']['manager']['services']['current'] = node.run_state['manager_services']
virtual_ips = node.run_state['virtual_ips']
virtual_ips_per_ip = node.run_state['virtual_ips_per_ip']

rb_common_config 'Configure common' do
  action :configure
end

rb_selinux_config 'Configure Selinux' do
  if shell_out('getenforce').stdout.chomp == 'Disabled'
    action :remove
  else
    action :add
  end
end

consul_config 'Configure Consul Server' do
  confdir node['consul']['confdir']
  datadir node['consul']['datadir']
  ipaddress node['ipaddress_sync']
  cdomain node['redborder']['cdomain']
  dns_local_ip node['consul']['dns_local_ip']
  (manager_services['consul'] ? (is_server true) : (is_server false))
  if manager_services['consul'] || manager_services['consul-client']
    action :add
  else
    action :remove
  end
end

chef_server_config 'Configure chef services' do
  memory node['redborder']['memory_services']['chef-server']['memory']
  postgresql false
  postgresql_memory node['redborder']['memory_services']['postgresql']['memory']
  chef_active manager_services['chef-server']
  ipaddress node['ipaddress_sync']
  if manager_services['chef-server']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

begin
  vrrp_secrets = data_bag_item('passwords', 'vrrp')
rescue
  vrrp_secrets = {}
end

keepalived_config 'Configure keepalived' do
  vrrp_secrets vrrp_secrets
  virtual_ips virtual_ips
  virtual_ips_per_ip virtual_ips_per_ip
  managers managers
  balanced_services node['redborder']['manager']['balanced']
  has_any_virtual_ip node.run_state['has_any_virtual_ip']
  manager_services manager_services
  ipmgt node['ipaddress']
  iface_management node['redborder']['management_interface']
  ipaddress_sync node['ipaddress_sync']
  managers_per_service node['redborder']['managers_per_services']
  if manager_services['keepalived']
    action :add
  else
    action :remove
  end
end

zookeeper_config 'Configure Zookeeper' do
  port node['zookeeper']['port']
  memory node['redborder']['memory_services']['zookeeper']['memory']
  hosts node['redborder']['managers_per_services']['zookeeper']
  ipaddress node['ipaddress_sync']
  if manager_services['zookeeper']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

kafka_config 'Configure Kafka' do
  memory node['redborder']['memory_services']['kafka']['memory']
  maxsize node['redborder']['manager']['hd_services_current']['kafka']
  managers_list node['redborder']['managers_per_services']['kafka']
  zk_hosts node['redborder']['zookeeper']['zk_hosts']
  host_index node['redborder']['kafka']['host_index']
  ipaddress node['ipaddress_sync']
  if manager_services['kafka']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

if manager_services['druid-coordinator'] || manager_services['druid-overlord'] || manager_services['druid-broker'] || manager_services['druid-middlemanager'] || manager_services['druid-historical'] || manager_services['druid-realtime']
  %w(druid-broker druid-coordinator druid-historical
  druid-middlemanager druid-overlord).each do |druid_service|
    service druid_service do
      supports status: true, start: true, restart: true, reload: true
      action :nothing
    end
  end

  druid_common 'Configure druid common resources' do
    name node['hostname']
    zookeeper_hosts node['redborder']['zookeeper']['zk_hosts']
    memcached_hosts node['redborder']['memcached']['hosts']
    s3_service 's3.service'
    s3_port node['minio']['port']
    cdomain node['redborder']['cdomain']
    action :add
    notifies :restart, 'service[druid-broker]', :delayed if manager_services['druid-broker']
    notifies :restart, 'service[druid-coordinator]', :delayed if manager_services['druid-coordinator]']
    notifies :restart, 'service[druid-historical]', :delayed if manager_services['druid-historical']
    notifies :restart, 'service[druid-middlemanager]', :delayed if manager_services['druid-middlemanager']
    notifies :restart, 'service[druid-overlord]', :delayed if manager_services['druid-overlord']
  end
else
  druid_common 'Delete druid common resources' do
    action :remove
  end
end

druid_coordinator 'Configure Druid Coordinator' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  memory_kb node['redborder']['memory_services']['druid-coordinator']['memory']
  if manager_services['druid-coordinator']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_overlord 'Configure Druid Overlord' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  memory_kb node['redborder']['memory_services']['druid-overlord']['memory']
  if manager_services['druid-overlord']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_broker 'Configure Druid Broker' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  memory_kb node['redborder']['memory_services']['druid-broker']['memory']
  if manager_services['druid-broker']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_middlemanager 'Configure Druid MiddleManager' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  memory_kb node['redborder']['memory_services']['druid-middlemanager']['memory']
  if manager_services['druid-middlemanager']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_historical 'Configure Druid Historical' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  memory_kb node['redborder']['memory_services']['druid-historical']['memory']
  if manager_services['druid-historical']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_realtime 'Configure Druid Realtime' do
  name node['hostname']
  ipaddress node['ipaddress_sync']
  zookeeper_hosts node['redborder']['zookeeper']['zk_hosts']
  partition_num node['redborder']['druid']['realtime']['partition_num']
  memory_kb node['redborder']['memory_services']['druid-realtime']['memory']
  if manager_services['druid-realtime']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

memcached_config 'Configure Memcached' do
  memory node['redborder']['memory_services']['memcached']['memory']
  ipaddress node['ipaddress_sync']
  if manager_services['memcached']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

mongodb_config 'Configure Mongodb' do
  if manager_services['mongodb']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

hadoop_common 'Configure hadoop common resources' do
  name node['hostname']
  zookeeper_hosts node['redborder']['zookeeper']['zk_hosts']
  memory_kb node['redborder']['memory_services']['hadoop-nodemanager']['memory']
  containersMemory node['redborder']['hadoop']['containersMemory']
  if manager_services['hadoop-nodemanager'] || manager_services['hadoop-resourcemanager']
    action :add
  else
    action :remove
  end
end

hadoop_resourcemanager 'Configure Hadoop ResourceManager' do
  memory_kb node['redborder']['memory_services']['hadoop-resourcemanager']['memory']
  if manager_services['hadoop-resourcemanager']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

hadoop_nodemanager 'Configure Hadoop NodeManager' do
  memory_kb node['redborder']['memory_services']['hadoop-nodemanager']['memory']
  if manager_services['hadoop-nodemanager']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

samza_config 'Configure samza applications' do
  memory_per_container node['redborder']['samza']['memory_per_container']
  num_containers node['redborder']['samza']['num_containers']
  if manager_services['hadoop-nodemanager']
    action :add
  else
    action :remove
  end
end

geoip_config 'Configure GeoIP' do
  action :add
end

snmp_config 'Configure snmp' do
  hostname node['hostname']
  cdomain node['redborder']['cdomain']
  if manager_services['snmp']
    action :add
  else
    action :remove
  end
end

rbmonitor_config 'Configure redborder-monitor' do
  name node['hostname']
  device_nodes node.run_state['sensors_info_all']['device-sensor']
  flow_nodes node.run_state['sensors_info_all']['flow-sensor']
  managers node['redborder']['managers_list']
  cluster node['redborder']['cluster_info']
  hostip node['redborder']['cluster_info'][name]['ip']
  if manager_services['redborder-monitor']
    action :add
  else
    action :remove
  end
end

rbscanner_config 'Configure redborder-scanner' do
  scanner_nodes node.run_state['sensors_info_all']['scanner-sensor']
  if manager_services['redborder-scanner']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

nginx_config 'Configure Nginx' do
  cdomain node['redborder']['cdomain']
  if manager_services['nginx']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

nginx_config 'Configure Nginx Chef' do
  service_name 'erchef'
  cdomain node['redborder']['cdomain']
  if manager_services['nginx'] && manager_services['chef-server']
    action [:configure_certs, :add_erchef]
  else
    action :nothing
  end
end

nginx_config 'Configure Nginx aioutliers' do
  service_name 'rb-aioutliers'
  cdomain node['redborder']['cdomain']
  if manager_services['nginx'] && manager_services['rb-aioutliers']
    action [:configure_certs, :add_aioutliers]
  else
    action :nothing
  end
end

webui_config 'Configure WebUI' do
  hostname node['hostname']
  memory_kb node['redborder']['memory_services']['webui']['memory']
  cdomain node['redborder']['cdomain']
  port node['redborder']['webui']['port']
  if manager_services['webui']
    action [:add, :register, :configure_rsa]
  else
    action [:remove, :deregister]
  end
end

webui_config 'Configure Nginx WebUI' do
  hosts node['redborder']['webui']['hosts']
  cdomain node['redborder']['cdomain']
  port node['redborder']['webui']['port']
  if manager_services['webui'] && manager_services['nginx']
    action [:configure_certs, :add_webui_conf_nginx]
  else
    action :nothing
  end
end

http2k_config 'Configure Http2k' do
  domain node['redborder']['cdomain']
  kafka_hosts node['redborder']['managers_per_services']['kafka']
  memory node['redborder']['memory_services']['http2k']['memory']
  port node['redborder']['http2k']['port']
  proxy_nodes node.run_state['sensors_info']['proxy-sensor']
  ips_nodes node.run_state['sensors_info']['ips-sensor']
  ipsg_nodes node.run_state['sensors_info']['ipsg-sensor']
  ipscp_nodes node.run_state['sensors_info']['ipscp-sensor']
  organizations node['redborder']['organizations']
  locations_list node['redborder']['locations']
  if manager_services['http2k']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

http2k_config 'Configure Nginx Http2k' do
  domain node['redborder']['cdomain']
  port node['redborder']['http2k']['port']
  if manager_services['http2k'] && manager_services['nginx']
    action [:configure_certs, :add_http2k_conf_nginx]
  else
    action :nothing
  end
end

f2k_config 'Configure f2k' do
  sensors node.run_state['sensors_info']['flow-sensor']
  if manager_services['f2k']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

pmacct_config 'Configure pmacct' do
  sensors node.run_state['sensors_info']['flow-sensor']
  kafka_hosts node['redborder']['managers_per_services']['kafka']
  if manager_services['pmacct']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

logstash_config 'Configure logstash' do
  cdomain node['redborder']['cdomain']
  flow_nodes node.run_state['all_flow_sensors_info']['flow-sensor']
  namespaces node.run_state['namespaces']
  vault_nodes node.run_state['sensors_info_all']['vault-sensor']
  scanner_nodes node.run_state['sensors_info_all']['scanner-sensor']
  device_nodes node.run_state['sensors_info_all']['device-sensor']
  logstash_pipelines node.run_state['pipelines']
  if manager_services['logstash'] && node.run_state['pipelines'] && !node.run_state['pipelines'].empty?
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbdswatcher_config 'Configure redborder-dswatcher' do
  cdomain node['redborder']['cdomain']
  if manager_services['redborder-dswatcher']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbevents_counter_config 'Configure redborder-events-counter' do
  cdomain node['redborder']['cdomain']
  if manager_services['redborder-events-counter']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rsyslog_config 'Configure rsyslog' do
  vault_nodes node.run_state['sensors_info_all']['vault-sensor'] + node.run_state['sensors_info_all']['cep-sensor']
  ips_nodes node.run_state['sensors_info_all']['ips-sensor'] + node.run_state['sensors_info_all']['ipsv2-sensor'] + node.run_state['sensors_info_all']['ipscp-sensor']
  if manager_services['rsyslog']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbnmsp_config 'Configure redborder-nmsp' do
  memory node['redborder']['memory_services']['redborder-nmsp']['memory']
  proxy_nodes node.run_state['sensors_info_all']['proxy-sensor']
  flow_nodes node.run_state['sensors_info_all']['flow-sensor']
  hosts node['redborder']['zookeeper']['zk_hosts']
  if manager_services['redborder-nmsp']
    action [:add, :configure_keys, :register]
  else
    action [:remove, :deregister]
  end
end

n2klocd_config 'Configure n2klocd' do
  mse_nodes node.run_state['sensors_info_all']['mse-sensor']
  meraki_nodes node.run_state['sensors_info_all']['meraki-sensor']
  n2klocd_managers node['redborder']['managers_per_services']['n2klocd']
  memory node['redborder']['memory_services']['n2klocd']['memory']
  if manager_services['n2klocd']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbale_config 'Configure redborder-ale' do
  ale_nodes node.run_state['sensors_info_all']['ale-sensor']
  if node['redborder']['services']['redborder-ale']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rblogstatter_config 'Configure redborder-logstatter' do
  if node['redborder']['services']['rb-logstatter']
    action :add
  else
    action :remove
  end
end

rb_arubacentral_config 'Configure rb-arubacentral' do
  arubacentral_nodes node.run_state['sensors_info_all']['arubacentral-sensor']
  flow_nodes node.run_state['sensors_info_all']['flow-sensor']
  if node['redborder']['services']['rb-arubacentral']
    action :add
  else
    action :remove
  end
end

# freeradius_config 'Configure radiusd' do
#   flow_nodes node.run_state['sensors_info_all']['flow-sensor']
#   action (node['redborder']['services']['radiusd'] ? [:config_common, :config_manager, :register] : [:remove, :deregister])
# end

rbaioutliers_config 'Configure rb-aioutliers' do
  if manager_services['rb-aioutliers']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbcep_config 'Configure redborder-cep' do
  flow_nodes node.run_state['sensors_info_all']['flow-sensor']
  vault_nodes node.run_state['sensors_info_all']['vault-sensor']
  ips_nodes node.run_state['sensors_info_all']['ips-sensor'] + node.run_state['sensors_info_all']['ipsv2-sensor'] + node.run_state['sensors_info_all']['ipscp-sensor']
  if node['redborder']['services']['redborder-cep']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rb_postfix_config 'Configure postfix' do
  if node['redborder']['services']['postfix']
    action :add
  else
    action :remove
  end
end

rbcgroup_config 'Configure cgroups' do
  action :add
end

rb_clamav_config 'Configure ClamAV' do
  action(manager_services['clamav'] ? :add : :remove)
end

# Determine external
begin
  external_services = data_bag_item('rBglobal', 'external_services')
rescue
  external_services = {}
end

postgresql_config 'Configure postgresql' do
  cdomain node['redborder']['cdomain']
  ipaddress node['ipaddress_sync']
  if manager_services['postgresql'] && external_services['postgresql'] == 'onpremise'
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

begin
  s3_secrets = data_bag_item('passwords', 's3')
rescue
  ssh_secrets = {}
end

# Allow only s3 onpremise nodes for now..
minio_config 'Configure S3 (minio)' do
  ipaddress node['ipaddress_sync']
  access_key_id s3_secrets['s3_access_key_id']
  secret_key_id s3_secrets['s3_secret_key_id']
  if manager_services['s3'] && (external_services['s3'] == 'onpremise')
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

# First configure the cert for the service before configuring nginx
if manager_services['s3']
  nginx_config 'Configure S3 certs' do
    service_name 's3'
    cdomain node['redborder']['cdomain']
    action :configure_certs
  end
end

# Configure Nginx s3 onpremise nodes for now..
minio_config 'Configure Nginx S3 (minio)' do
  s3_hosts node['redborder']['s3']['s3_hosts']
  if manager_services['s3'] && (external_services['s3'] == 'onpremise')
    action [:add_s3_conf_nginx]
  end
end

begin
  ssh_secrets = data_bag_item('passwords', 'ssh')
rescue
  ssh_secrets = {}
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

unless ssh_secrets.empty?
  template '/root/.ssh/authorized_keys' do
    source 'rsa.pub.erb'
    owner 'root'
    group 'root'
    mode '0600'
    retries 2
    variables(public_rsa: ssh_secrets['public_rsa'])
  end
end

# Sudoers
template '/etc/sudoers.d/redborder-manager' do
  source 'redborder-manager.erb'
  owner 'root'
  group 'root'
  mode '0440'
  retries 2
end

# Pending Changes..
# pending_changes==0 -> has changes to apply at next chef-client run
#  pending_changes==1 -> chef-client has to run once
#  pending_changes==2 -> chef-client has to run twice
#  .......
#  pending_changes==n -> chef-client has to run n times
#
node.normal['redborder']['pending_changes'] = node['redborder']['pending_changes'] > 0 ? node.normal['redborder']['pending_changes'].to_i - 1 : 0

execute 'force_chef_client_wakeup' do
  command '/usr/lib/redborder/bin/rb_wakeup_chef.sh'
  ignore_failure true
  if node['redborder']['pending_changes'].nil? || node['redborder']['pending_changes'] == 0
    action :nothing
  else
    action :run
  end
end

# MOTD
cluster_info = node['redborder']['cluster_info']

begin
  cluster_uuid_db = data_bag_item('rBglobal', 'cluster')
rescue
  cluster_uuid_db = {}
end

cluster_installed = File.exist?('/etc/redborder/cluster-installed.txt')

template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  retries 2
  backup false
  variables(cluster_info: cluster_info,
            uuid: cluster_uuid_db['uuid'],
            manager_services: manager_services,
            cluster_finished: cluster_installed)
end
