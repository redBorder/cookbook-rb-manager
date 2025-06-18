# Cookbook:: manager
# Recipe:: configure
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

Chef::Recipe.include RbManager::Helpers

# Services configuration

# manager services
managers = node.run_state['managers']
manager_services = node.run_state['manager_services']
node.default['redborder']['manager']['services']['current'] = node.run_state['manager_services']
virtual_ips = node.run_state['virtual_ips']
virtual_ips_per_ip = node.run_state['virtual_ips_per_ip']
user_sensor_map_data = get_user_sensor_map
is_consul_server = consul_server?

# bash 'upload_cookbooks' do
#   code 'bash /usr/lib/redborder/bin/rb_upload_cookbooks.sh'
#   only_if { ::File.exist?('/root/.upload-cookbooks') }
#   notifies :delete, 'file[/root/.upload-cookbooks]', :immediately
# end

# file '/root/.upload-cookbooks' do
#   action :nothing
# end

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

# Sudoers
template '/etc/sudoers.d/redborder-manager' do
  source 'redborder-manager.erb'
  owner 'root'
  group 'root'
  mode '0440'
  retries 2
end

rb_firewall_config 'Configure Firewall' do
  sync_ip node['ipaddress_sync']
  ip_addr node['ipaddress']
  if manager_services['firewall']
    action :add
  else
    action :remove
  end
end

consul_config 'Configure Consul Server' do
  cdomain node['redborder']['cdomain']
  dns_local_ip node['consul']['dns_local_ip']

  if manager_services['consul']
    confdir node['consul']['confdir']
    datadir node['consul']['datadir']
    ipaddress node['ipaddress_sync']
    is_server is_consul_server
    action :add
  else
    action :remove
  end
end

chef_server_config 'Configure chef services' do
  if manager_services['chef-server']
    memory node['redborder']['memory_services']['chef-server']['memory']
    postgresql false
    postgresql_memory node['redborder']['memory_services']['postgresql']['memory']
    chef_active manager_services['chef-server']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

vrrp_secrets = {}

if manager_services['keepalived']
  begin
    vrrp_secrets = data_bag_item('passwords', 'vrrp').to_hash
  rescue
    vrrp_secrets = {}
  end
end

keepalived_config 'Configure keepalived' do
  if manager_services['keepalived']
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
    action :add
  else
    action :remove
  end
end

zookeeper_config 'Configure Zookeeper' do
  if manager_services['zookeeper']
    port node['zookeeper']['port']
    memory node['redborder']['memory_services']['zookeeper']['memory']
    hosts node['redborder']['managers_per_services']['zookeeper']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

kafka_config 'Configure Kafka' do
  if manager_services['kafka']
    memory node['redborder']['memory_services']['kafka']['memory']
    maxsize node['redborder']['manager']['hd_services_current']['kafka']
    managers_list node['redborder']['managers_per_services']['kafka']
    zk_hosts node['redborder']['zookeeper']['zk_hosts']
    host_index node['redborder']['kafka']['host_index']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

s3_secrets = {}

begin
  s3_secrets = data_bag_item('passwords', 's3')
rescue
  s3_secrets = {}
end

if manager_services['druid-coordinator'] || manager_services['druid-overlord'] || manager_services['druid-broker'] || manager_services['druid-middlemanager'] || manager_services['druid-historical'] || manager_services['druid-indexer']
  %w(druid-broker druid-coordinator druid-historical
  druid-middlemanager druid-overlord druid-router druid-indexer).each do |druid_service|
    service druid_service do
      supports status: true, start: true, restart: true, reload: true
      action :nothing
    end
  end

  druid_common 'Configure druid common resources' do
    name node['hostname']
    zookeeper_hosts node['redborder']['zookeeper']['zk_hosts']
    memcached_hosts node['redborder']['memcached']['hosts']
    s3_service s3_secrets['s3_host']
    s3_port node['minio']['port']
    action :add
    notifies :restart, 'service[druid-broker]', :delayed if manager_services['druid-broker']
    notifies :restart, 'service[druid-coordinator]', :delayed if manager_services['druid-coordinator']
    notifies :restart, 'service[druid-historical]', :delayed if manager_services['druid-historical']
    notifies :restart, 'service[druid-middlemanager]', :delayed if manager_services['druid-middlemanager']
    notifies :restart, 'service[druid-overlord]', :delayed if manager_services['druid-overlord']
    notifies :restart, 'service[druid-indexer]', :delayed if manager_services['druid-indexer']
    notifies :restart, 'service[druid-router]', :delayed if manager_services['druid-router']
  end
else
  druid_common 'Delete druid common resources' do
    action :remove
  end
end

druid_coordinator 'Configure Druid Coordinator' do
  if manager_services['druid-coordinator']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-coordinator']['memory']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_overlord 'Configure Druid Overlord' do
  if manager_services['druid-overlord']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-overlord']['memory']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_broker 'Configure Druid Broker' do
  if manager_services['druid-broker']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-broker']['memory']
    cpu_num node['cpu']['total'].to_i
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_middlemanager 'Configure Druid MiddleManager' do
  if manager_services['druid-middlemanager']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-middlemanager']['memory']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_historical 'Configure Druid Historical' do
  if manager_services['druid-historical']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-historical']['memory']
    maxsize node['redborder']['manager']['hd_services_current']['druid-historical'].to_i
    cpu_num node['cpu']['total'].to_i
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rb_druid_indexer_config 'Configure Rb Druid Indexer' do
  if manager_services['rb-druid-indexer']
    zk_hosts node['redborder']['managers_per_services']['zookeeper']
    kafka_brokers node['redborder']['managers_per_services']['kafka']
    namespaces node.run_state['namespaces']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_indexer 'Configure Druid Indexer' do
  if manager_services['druid-indexer']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    memory_kb node['redborder']['memory_services']['druid-indexer']['memory']
    cpu_num node['cpu']['total'].to_i
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

druid_router 'Configure Druid Router' do
  if manager_services['druid-router']
    name node['hostname']
    cdomain node['redborder']['cdomain']
    memory_kb node['redborder']['memory_services']['druid-router']['memory']
    cpu_num node['cpu']['total'].to_i
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

memcached_config 'Configure Memcached' do
  if manager_services['memcached']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

enable_mongodb = false
if manager_services['mongodb']
  is_mongo_configured_consul = shell_out("curl -s http://localhost:8500/v1/health/service/mongodb | jq -r '.[].Checks[0].Status' | grep -q 'passing'")
  get_consul_registered_ip = shell_out("curl -s http://localhost:8500/v1/health/service/mongodb | jq -r '.[].Service.Address' | head -n 1")
  enable_mongodb = (is_mongo_configured_consul.exitstatus != 0) ? true : (node['ipaddress_sync'] == get_consul_registered_ip.stdout.strip)
end

mongodb_config 'Configure Mongodb' do
  if enable_mongodb
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

geoip_config 'Configure GeoIP' do
  user_id node['redborder']['geoip_user']
  license_key node['redborder']['geoip_key']
  action :add
end

snmp_config 'Configure snmp' do
  if manager_services['snmp']
    hostname node['hostname']
    cdomain node['redborder']['cdomain']
    action :add
  else
    action :remove
  end
end

rbmonitor_config 'Configure redborder-monitor' do
  if manager_services['redborder-monitor']
    name node['hostname']
    device_nodes node.run_state['sensors_info_all']['device-sensor']
    flow_nodes node.run_state['sensors_info_all']['flow-sensor']
    managers node['redborder']['managers_list']
    cluster node['redborder']['cluster_info']
    hostip node['redborder']['cluster_info'][name]['ip']
    action :add
  else
    action :remove
  end
end

rbscanner_config 'Configure redborder-scanner' do
  if manager_services['redborder-scanner']
    scanner_nodes node.run_state['sensors_info_all']['scanner-sensor']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

nginx_config 'Configure Nginx' do
  if manager_services['nginx']
    cdomain node['redborder']['cdomain']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

nginx_config 'Configure Nginx Chef' do
  if manager_services['nginx'] && node['redborder']['erchef']['hosts'] && !node['redborder']['erchef']['hosts'].empty?
    erchef_hosts node['redborder']['erchef']['hosts']
    cdomain node['redborder']['cdomain']
    service_name 'erchef'
    action [:configure_certs, :add_erchef]
  else
    action :nothing
  end
end

nginx_config 'Configure Nginx aioutliers' do
  if manager_services['nginx'] && node['redborder']['rb-aioutliers']['hosts'] && !node['redborder']['rb-aioutliers']['hosts'].empty?
    aioutliers_hosts node['redborder']['rb-aioutliers']['hosts']
    service_name 'rb-aioutliers'
    action [:configure_certs, :add_aioutliers]
  elsif manager_services['nginx']
    action :remove_aioutliers
  else
    action :nothing
  end
end

webui_config 'Configure WebUI' do
  if manager_services['webui']
    hostname node['hostname']
    memcached_servers node['redborder']['managers_per_services']['memcached']
    memory_kb node['redborder']['memory_services']['webui']['memory']
    cdomain node['redborder']['cdomain']
    port node['redborder']['webui']['port']
    webui_version node['redborder']['webui']['version']
    redborder_version node['redborder']['repo']['version']
    user_sensor_map user_sensor_map_data
    action [:add, :register, :configure_rsa]
  else
    action [:remove, :deregister]
  end
end

webui_config 'Configure Nginx WebUI' do
  if manager_services['nginx'] && node['redborder']['webui']['hosts'] && !node['redborder']['webui']['hosts'].empty?
    hosts node['redborder']['webui']['hosts']
    cdomain node['redborder']['cdomain']
    port node['redborder']['webui']['port']
    action [:configure_certs, :add_webui_conf_nginx]
  else
    action :nothing
  end
end

http2k_config 'Configure Http2k' do
  if manager_services['http2k']
    domain node['redborder']['cdomain']
    kafka_hosts node['redborder']['managers_per_services']['kafka']
    memory node['redborder']['memory_services']['http2k']['memory']
    port node['redborder']['http2k']['port']
    proxy_nodes node.run_state['sensors_info']['proxy-sensor']
    ips_nodes node.run_state['sensors_info']['ips-sensor']
    ipsg_nodes node.run_state['sensors_info']['ipsg-sensor']
    ipscp_nodes node.run_state['sensors_info']['ipscp-sensor']
    intrusion_nodes node.run_state['sensors_info']['intrusion-sensor']
    intrusioncp_nodes node.run_state['sensors_info']['intrusioncp-sensor']
    organizations node.run_state['organizations']
    locations_list node['redborder']['locations']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

nginx_config 'Configure Nginx Http2k' do
  if manager_services['nginx'] && node['redborder']['http2k']['hosts'] && !node['redborder']['http2k']['hosts'].empty?
    http2k_hosts node['redborder']['http2k']['hosts']
    http2k_port node['redborder']['http2k']['port']
    cdomain node['redborder']['cdomain']
    service_name 'http2k'
    action [:configure_certs, :add_http2k]
  elsif manager_services['nginx']
    action :remove_http2k
  else
    action :nothing
  end
end

f2k_config 'Configure f2k' do
  if manager_services['f2k']
    sensors node.run_state['sensors_info']['flow-sensor']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

if manager_services['sfacctd'] &&
   node.run_state['virtual_ips'] &&
   node.run_state['virtual_ips']['external'] &&
   node.run_state['virtual_ips']['external']['sfacctd'] &&
   node.run_state['virtual_ips']['external']['sfacctd']['ip']

  sfacctd_ip = '0.0.0.0'
end

pmacct_config 'Configure pmacct (sfacctd)' do
  if manager_services['sfacctd']
    sensors node.run_state['sensors_info']['flow-sensor']
    kafka_hosts node['redborder']['managers_per_services']['kafka']
    sfacctd_ip sfacctd_ip || node['ipaddress']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

# Configure logstash
split_traffic = false

if manager_services['logstash']
  begin
    split_traffic = data_bag_item('rBglobal', 'splittraffic')['logstash']
  rescue
    split_traffic = false
  end
end

if manager_services['logstash']
  begin
    split_intrusion = data_bag_item('rBglobal', 'splitintrusion')['logstash']
  rescue
    split_intrusion = false
  end
end

logstash_config 'Configure logstash' do
  if manager_services['logstash'] && node.run_state['pipelines'] && !node.run_state['pipelines'].empty?
    cdomain node['redborder']['cdomain']
    flow_nodes node.run_state['flow_sensors_info']
    namespaces node.run_state['namespaces']
    vault_nodes node.run_state['sensors_info_all']['vault-sensor']
    proxy_nodes node.run_state['sensors_info_all']['proxy-sensor']
    scanner_nodes node.run_state['sensors_info_all']['scanner-sensor']
    device_nodes node.run_state['sensors_info_all']['device-sensor']
    ips_nodes node.run_state['ips_sensors_info']
    mobility_nodes node.run_state['mobility_sensors_info']
    intrusion_incidents_priority_filter node['redborder']['intrusion_incidents_priority_filter']
    vault_incidents_priority_filter node['redborder']['vault_incidents_priority_filter']
    logstash_pipelines node.run_state['pipelines']
    split_traffic_logstash split_traffic
    split_intrusion_logstash split_intrusion
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbdswatcher_config 'Configure redborder-dswatcher' do
  if manager_services['redborder-dswatcher']
    cdomain node['redborder']['cdomain']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbevents_counter_config 'Configure redborder-events-counter' do
  if manager_services['redborder-events-counter']
    cdomain node['redborder']['cdomain']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rsyslog_config 'Configure rsyslog' do
  if manager_services['rsyslog']
    vault_nodes node.run_state['sensors_info_all']['vault-sensor'] + node.run_state['sensors_info_all']['cep-sensor']
    ips_nodes node.run_state['sensors_info_all']['ips-sensor'] + node.run_state['sensors_info_all']['ipsv2-sensor'] + node.run_state['sensors_info_all']['ipscp-sensor']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbnmsp_config 'Configure redborder-nmsp' do
  if manager_services['redborder-nmsp']
    memory node['redborder']['memory_services']['redborder-nmsp']['memory']
    proxy_nodes node.run_state['sensors_info_all']['proxy-sensor']
    flow_nodes node.run_state['sensors_info_all']['flow-sensor']
    hosts node['redborder']['zookeeper']['zk_hosts']
    action [:add, :configure_keys, :register]
  else
    action [:remove, :deregister]
  end
end

n2klocd_config 'Configure n2klocd' do
  if manager_services['n2klocd']
    mse_nodes node.run_state['sensors_info_all']['mse-sensor']
    meraki_nodes node.run_state['sensors_info_all']['meraki-sensor']
    n2klocd_managers node['redborder']['managers_per_services']['n2klocd']
    memory node['redborder']['memory_services']['n2klocd']['memory']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbale_config 'Configure redborder-ale' do
  if manager_services['redborder-ale']
    ale_nodes node.run_state['sensors_info_all']['ale-sensor']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rblogstatter_config 'Configure redborder-logstatter' do
  if manager_services['rb-logstatter'] && manager_services['logstash'] && node.run_state['pipelines'] && !node.run_state['pipelines'].empty?
    action :add
  else
    action :remove
  end
end

rb_arubacentral_config 'Configure rb-arubacentral' do
  if manager_services['rb-arubacentral']
    arubacentral_nodes node.run_state['sensors_info_all']['arubacentral-sensor']
    flow_nodes node.run_state['sensors_info_all']['flow-sensor']
    action :add
  else
    action :remove
  end
end

# freeradius_config 'Configure radiusd' do
#   flow_nodes node.run_state['sensors_info_all']['flow-sensor']
#   action (manager_services['radiusd'] ? [:config_common, :config_manager, :register] : [:remove, :deregister])
# end

rbaioutliers_config 'Configure rb-aioutliers' do
  if manager_services['rb-aioutliers']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rbcep_config 'Configure redborder-cep' do
  if manager_services['redborder-cep']
    flow_nodes node.run_state['sensors_info_all']['flow-sensor']
    vault_nodes node.run_state['sensors_info_all']['vault-sensor']
    ips_nodes node.run_state['sensors_info_all']['ips-sensor'] + node.run_state['sensors_info_all']['ipsv2-sensor'] + node.run_state['sensors_info_all']['ipscp-sensor']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

mem2incident_config 'Configure redborder-mem2incident' do
  if manager_services['redborder-mem2incident']
    cdomain node['redborder']['cdomain']
    memcached_servers node['redborder']['managers_per_services']['memcached'].map { |s| "#{s}:#{node['redborder']['memcached']['port']}" }
    auth_token node.run_state['auth_token']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rb_llm_config 'Configure redborder-llm' do
  if manager_services['redborder-llm']
    llm_selected_model node['redborder']['llm_selected_model']
    cpus node['redborder']['redborder-llm']['cpus']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

rb_postfix_config 'Configure postfix' do
  if manager_services['postfix']
    action :add
  else
    action :remove
  end
end

rb_clamav_config 'Configure ClamAV' do
  action :add
end

rb_chrony_config 'Configure Chrony' do
  if manager_services['chrony']
    ntp_servers node['redborder']['ntp']['servers']
    action :add
  else
    action :remove
  end
end

# Determine external
begin
  external_services = data_bag_item('rBglobal', 'external_services')
rescue => e
  Chef::Log.warn("Failed to load external_services data bag: #{e.message}")
  external_services = nil
end

postgresql_config 'Configure postgresql' do
  if manager_services['postgresql'] && external_services&.dig('postgresql') == 'onpremise'
    cdomain node['redborder']['cdomain']
    ipaddress node['ipaddress_sync']
    action [:add, :register]
  elsif !external_services.nil?
    action [:remove, :deregister]
  else
    Chef::Log.warn('Skipped PostgreSQL removal/deregistration due to missing external_services data')
    action :nothing
  end
end

template '/root/.s3cfg_initial' do
  source 's3cfg_initial.erb'
  cookbook 'minio'
  variables(
    s3_user: s3_secrets['s3_access_key_id'],
    s3_password: s3_secrets['s3_secret_key_id'],
    s3_endpoint: s3_secrets['s3_host']
  )
  action :create
  only_if do
    s3_secrets['s3_access_key_id'] && !s3_secrets['s3_access_key_id'].empty? &&
      s3_secrets['s3_secret_key_id'] && !s3_secrets['s3_secret_key_id'].empty? &&
      s3_secrets['s3_host'] && !s3_secrets['s3_host'].empty?
  end
end

# Allow only s3 onpremise nodes for now..
minio_config 'Configure S3 (minio)' do
  managers_with_minio node['redborder']['managers_per_services']['s3']
  access_key_id s3_secrets['s3_access_key_id']
  secret_key_id s3_secrets['s3_secret_key_id']
  if manager_services['s3'] && external_services&.dig('s3') == 'onpremise'
    ipaddress node['ipaddress_sync']
    action [:add_mcli, :add, :register]
  elsif !external_services.nil?
    action [:add_mcli, :remove, :deregister]
  else
    Chef::Log.warn('Skipped MinIO removal/deregistration due to missing external_services data')
    action :nothing
  end
end

# Configure secor service for backup kafka data in case of data lose and for view raw vault data
secor_config 'Configure Secor Service' do
  if manager_services['secor'] || manager_services['secor-vault']
    kafka_hosts node['redborder']['managers_per_services']['kafka']
    zk_hosts node['redborder']['zookeeper']['zk_hosts']
    manager_services manager_services
    s3_server s3_secrets['s3_host']
    s3_hostname s3_secrets['s3_host']
    s3_user s3_secrets['s3_access_key_id']
    s3_pass s3_secrets['s3_secret_key_id']
    s3_bucket 'bucket'
    s3_port node['minio']['port']
    action :add
  else
    action :remove
  end
end

rbcgroup_config 'Configure cgroups' do
  check_cgroups node.run_state['cluster_installed']
  action :add
end

# First configure the cert for the service before configuring nginx
nginx_config 'Configure S3 certs' do
  if manager_services['s3']
    service_name 's3'
    cdomain node['redborder']['cdomain']
    action :configure_certs
  else
    action :nothing
  end
end

# Configure Nginx s3 onpremise nodes for now..
minio_config 'Configure Nginx S3 (minio)' do
  if manager_services['s3'] && external_services&.dig('s3') == 'onpremise'
    s3_hosts node['redborder']['s3']['s3_hosts']
    action [:add_s3_conf_nginx]
  elsif !manager_services['s3'] && manager_services['nginx']
    s3_hosts node['redborder']['s3']['s3_hosts']
    action [:add_s3_conf_nginx]
  else
    action :nothing
  end
end

ssh_secrets = {}

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
  template '/root/.ssh/rsa.pub' do
    source 'rsa.pub.erb'
    owner 'root'
    group 'root'
    mode '0600'
    retries 2
    variables(public_rsa: ssh_secrets['public_rsa'])
  end
end

begin
  rsa_pem = data_bag_item('certs', 'rsa_pem')
rescue
  rsa_pem = nil
end

unless rsa_pem.empty?
  template '/root/.ssh/rsa' do
    source 'rsa_cert.pem.erb'
    owner 'root'
    group 'root'
    mode '0600'
    retries 2
    variables(private_rsa: rsa_pem['private_rsa'])
  end
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
cluster_uuid_db = {}

begin
  cluster_uuid_db = data_bag_item('rBglobal', 'cluster')
rescue
  cluster_uuid_db = {}
end

template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  retries 2
  backup false
  variables(cluster_info: node['redborder']['cluster_info'],
            uuid: cluster_uuid_db['uuid'],
            manager_services: manager_services,
            cluster_finished: node.run_state['cluster_installed'])
end
