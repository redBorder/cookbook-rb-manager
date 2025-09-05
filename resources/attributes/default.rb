# general
default['redborder']['cdomain'] = 'redborder.cluster'
default['redborder']['organization_uuid'] = nil
default['redborder']['organizations'] = []
default['redborder']['locations'] = %w(namespace namespace_uuid organization organization_uuid service_provider service_provider_uuid deployment deployment_uuid market market_uuid campus campus_uuid building building_uuid floor floor_uuid)
default['redborder']['sso_enabled'] = '0'
default['redborder']['repo'] = {}
default['redborder']['repo']['version'] = nil

# s3
default['redborder']['uploaded_s3'] = false
default['redborder']['s3']['s3_hosts'] = []

# chef-client
default['chef-client']['interval'] = 300
default['chef-client']['splay'] = 100
default['chef-client']['options'] = ''

# kafka
default['redborder']['kafka']['port'] = 9092
default['redborder']['kafka']['logdir'] = '/var/log/kafka'
default['redborder']['kafka']['host_index'] = 0

# zookeeper
default['redborder']['zookeeper']['zk_hosts'] = ''
default['redborder']['zookeeper']['port'] = 2181

# http2k
default['redborder']['http2k']['port'] = 7980

# webui
default['redborder']['webui']['port'] = 8001
default['redborder']['webui']['hosts'] = []
default['redborder']['webui']['version'] = nil

# memcached
default['redborder']['memcached']['elasticache'] = false
default['redborder']['memcached']['server_list'] = []
default['redborder']['memcached']['options'] = ''
default['redborder']['memcached']['port'] = 11211

# redis
default['redis']['port'] = 26379
default['redis']['sentinel_port'] = 26380

# aerospike
default['aerospike']['port'] = 3000
default['aerospike']['multicast'] = '239.1.99.222'

# hard disk
default['redborder']['manager']['data_dev'] = {}
default['redborder']['manager']['data_dev']['root'] = '/dev/mapper/VolGroup-lv_root'
default['redborder']['manager']['data_dev']['raw'] = '/dev/mapper/vg_rbdata-lv_raw'
default['redborder']['manager']['data_dev']['aggregate'] = '/dev/mapper/vg_rbdata-lv_aggregated'
default['redborder']['manager']['hd_services'] = [
                                                   { 'name': 'kafka', 'count': 5, 'prefered': 'aggregate' },
                                                   { 'name': 'zookeeper', 'count': 1, 'prefered': 'aggregate' },
                                                   { 'name': 's3', 'count': 50, 'prefered': 'raw' },
                                                   { 'name': 'druid-historical', 'count': 50, 'prefered': 'raw' },
                                                 ]

default['redborder']['manager']['hd_services_current'] = {}

# memory
default['redborder']['memory_services'] = {}
default['redborder']['memory_services']['chef-server'] = { 'count': 25, 'memory': 0 }
default['redborder']['memory_services']['druid-broker'] = { 'count': 100, 'memory': 0 }
default['redborder']['memory_services']['druid-coordinator'] = { 'count': 30, 'memory': 0 }
default['redborder']['memory_services']['druid-historical'] = { 'count': 90, 'memory': 0 }
default['redborder']['memory_services']['druid-middlemanager'] = { 'count': 1000, 'memory': 0 }
default['redborder']['memory_services']['druid-overlord'] = { 'count': 20, 'memory': 0 }
default['redborder']['memory_services']['druid-indexer'] = { 'count': 130, 'memory': 0 }
default['redborder']['memory_services']['druid-router'] = { 'count': 20, 'memory': 0 }
default['redborder']['memory_services']['f2k'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['http2k'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['kafka'] = { 'count': 120, 'memory': 0, 'max_limit': 524288 }
default['redborder']['memory_services']['n2klocd'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['postgresql'] = { 'count': 25, 'memory': 0 }
default['redborder']['memory_services']['aerospike'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['rb-aioutliers'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['redborder-agents'] = { 'count': 5, 'memory': 0 }
default['redborder']['memory_services']['redborder-cep'] = { 'count': 80, 'memory': 0 }
default['redborder']['memory_services']['redborder-mem2incident'] = { 'count': 5, 'memory': 0 }
default['redborder']['memory_services']['redborder-nmsp'] = { 'count': 100, 'memory': 0 }
default['redborder']['memory_services']['webui'] = { 'count': 100, 'memory': 0 }
default['redborder']['memory_services']['zookeeper'] = { 'count': 40, 'memory': 0 }
default['redborder']['memory_services']['secor'] = { 'count': 30, 'memory': 0 }
default['redborder']['memory_services']['secor-vault'] = { 'count': 30, 'memory': 0 }
default['redborder']['memory_services']['redis'] = { 'count': 10, 'memory': 0 }

# default attributes for managers_info, it would be rewriten with the cluster config
default['redborder']['cluster_info'] = {}
default['redborder']['cluster_info'][node['hostname']] = {}
default['redborder']['cluster_info'][node['hostname']]['ip'] = node['ipaddress']

default['redborder']['managers_per_services'] = {}

default['redborder']['managers_list'] = ['localhost']
default['redborder']['zookeeper_hosts'] = []

default['redborder']['memory_assigned'] = {}

# geoip has been removed because is not a service
default['redborder']['services_group']['full'] = %w(consul chef-server zookeeper memcached rsyslog kafka logstash s3
                                                    druid-broker druid-historical druid-coordinator druid-router druid-indexer druid-overlord
                                                    postgresql aerospike nginx webui rb-workers f2k rb-druid-indexer
                                                    redborder-monitor sfacctd redborder-dswatcher redis
                                                    redborder-events-counter http2k redborder-mem2incident rb-logstatter)

default['redborder']['services_group']['custom'] = %w(consul)
default['redborder']['services_group']['core'] = %w(consul chef-server s3 postgresql nginx)
default['redborder']['services_group']['chef'] = %w(consul chef-server)
default['redborder']['services_group']['kafka'] = %w(consul kafka)
default['redborder']['services_group']['historical'] = %w(consul druid-historical)
default['redborder']['services_group']['middlemanager'] = %w(consul druid-middlemanager)
default['redborder']['services_group']['broker'] = %w(consul druid-broker)
default['redborder']['services_group']['http2k'] = %w(consul http2k)
default['redborder']['services_group']['webui'] = %w(consul nginx webui rb-workers)
default['redborder']['services_group']['f2k'] = %w(consul f2k)
default['redborder']['services_group']['s3'] = %w(consul nginx s3)
default['redborder']['services_group']['postgresql'] = %w(consul postgresql)

default['redborder']['services'] = {}
default['redborder']['services']['aerospike']                 = true
default['redborder']['services']['chef-client']               = true
default['redborder']['services']['chef-server']               = false
default['redborder']['services']['chrony']                    = true
default['redborder']['services']['consul']                    = false
default['redborder']['services']['druid-broker']              = false
default['redborder']['services']['druid-coordinator']         = false
default['redborder']['services']['druid-historical']          = false
default['redborder']['services']['druid-middlemanager']       = false
default['redborder']['services']['druid-overlord']            = false
default['redborder']['services']['druid-indexer']             = false
default['redborder']['services']['druid-router']              = false
default['redborder']['services']['rb-druid-indexer']          = false
default['redborder']['services']['f2k']                       = false
default['redborder']['services']['http2k']                    = false
default['redborder']['services']['kafka']                     = false
default['redborder']['services']['keepalived']                = false
default['redborder']['services']['logstash']                  = false
default['redborder']['services']['memcached']                 = true
default['redborder']['services']['n2klocd']                   = false
default['redborder']['services']['nginx']                     = false
default['redborder']['services']['sfacct']                    = false
default['redborder']['services']['postfix']                   = true
default['redborder']['services']['postgresql']                = false
default['redborder']['services']['radiusd']                   = false
default['redborder']['services']['rb-aioutliers']             = false
default['redborder']['services']['rb-arubacentral']           = false
default['redborder']['services']['rb-logstatter']             = false
default['redborder']['services']['rb-workers']                = false
default['redborder']['services']['redborder-agents']          = false
default['redborder']['services']['redborder-ale']             = false
default['redborder']['services']['redborder-cep']             = false
default['redborder']['services']['redborder-dswatcher']       = false
default['redborder']['services']['redborder-events-counter']  = false
default['redborder']['services']['redborder-mem2incident']    = false
default['redborder']['services']['redborder-monitor']         = true
default['redborder']['services']['redborder-nmsp']            = false
default['redborder']['services']['redborder-scanner']         = false
default['redborder']['services']['rsyslog']                   = true
default['redborder']['services']['s3']                        = false
default['redborder']['services']['snmp']                      = true
default['redborder']['services']['webui']                     = false
default['redborder']['services']['zookeeper']                 = false
default['redborder']['services']['firewall']                  = true
default['redborder']['services']['secor']                     = false
default['redborder']['services']['secor-vault']               = false
default['redborder']['services']['redis']                     = false

default['redborder']['systemdservices']['aerospike']                = ['aerospike']
default['redborder']['systemdservices']['chef-client']              = ['chef-client']
default['redborder']['systemdservices']['chef-server']              = ['opscode-erchef']
default['redborder']['systemdservices']['chrony']                   = ['chronyd']
default['redborder']['systemdservices']['consul']                   = ['consul']
default['redborder']['systemdservices']['druid-broker']             = ['druid-broker']
default['redborder']['systemdservices']['druid-coordinator']        = ['druid-coordinator']
default['redborder']['systemdservices']['druid-middlemanager']      = ['druid-middlemanager']
default['redborder']['systemdservices']['druid-historical']         = ['druid-historical']
default['redborder']['systemdservices']['druid-overlord']           = ['druid-overlord']
default['redborder']['systemdservices']['druid-indexer']            = ['druid-indexer']
default['redborder']['systemdservices']['druid-router']             = ['druid-router']
default['redborder']['systemdservices']['rb-druid-indexer']         = ['rb-druid-indexer']
default['redborder']['systemdservices']['f2k']                      = ['f2k']
default['redborder']['systemdservices']['http2k']                   = ['http2k']
default['redborder']['systemdservices']['kafka']                    = ['kafka']
default['redborder']['systemdservices']['keepalived']               = ['keepalived']
default['redborder']['systemdservices']['logstash']                 = ['logstash']
default['redborder']['systemdservices']['memcached']                = ['memcached']
default['redborder']['systemdservices']['n2klocd']                  = ['n2klocd']
default['redborder']['systemdservices']['nginx']                    = ['nginx']
default['redborder']['systemdservices']['sfacctd']                  = ['sfacctd']
default['redborder']['systemdservices']['postfix']                  = ['postfix']
default['redborder']['systemdservices']['postgresql']               = ['postgresql']
default['redborder']['systemdservices']['radiusd']                  = ['radiusd']
default['redborder']['systemdservices']['rb-aioutliers']            = ['rb-aioutliers']
default['redborder']['systemdservices']['rb-arubacentral']          = ['rb-arubacentral']
default['redborder']['systemdservices']['rb-logstatter']            = ['rb-logstatter']
default['redborder']['systemdservices']['rb-workers']               = ['rb-workers']
default['redborder']['systemdservices']['redborder-agents']         = ['redborder-agents']
default['redborder']['systemdservices']['redborder-ale']            = ['redborder-ale']
default['redborder']['systemdservices']['redborder-cep']            = ['redborder-cep']
default['redborder']['systemdservices']['redborder-dswatcher']      = ['redborder-dswatcher']
default['redborder']['systemdservices']['redborder-events-counter'] = ['redborder-events-counter']
default['redborder']['systemdservices']['redborder-mem2incident']   = ['redborder-mem2incident']
default['redborder']['systemdservices']['redborder-monitor']        = ['redborder-monitor']
default['redborder']['systemdservices']['redborder-nmsp']           = ['redborder-nmsp']
default['redborder']['systemdservices']['redborder-scanner']        = ['redborder-scanner']
default['redborder']['systemdservices']['rsyslog']                  = ['rsyslog']
default['redborder']['systemdservices']['s3']                       = ['minio']
default['redborder']['systemdservices']['snmp']                     = ['snmpd']
default['redborder']['systemdservices']['webui']                    = ['webui']
default['redborder']['systemdservices']['zookeeper']                = ['zookeeper']
default['redborder']['systemdservices']['firewall']                 = ['firewalld']
default['redborder']['systemdservices']['secor']                    = ['rb-secor']
default['redborder']['systemdservices']['secor-vault']              = ['rb-secor-vault']
default['redborder']['systemdservices']['redis']                    = ['redis']

default['redborder']['manager']['balanced'] = [ { port: 443, protocol: 'tcp', name: 'redborder webui', service: 'webui', redirected_service: 'nginx', persistence_timeout: 9600 }, { port: 2055, protocol: 'udp', name: 'netflow,ipfix/sflow daemon', service: 'f2k', redirected_service: 'f2k', persistence_timeout: 30 }, { port: 6343, protocol: 'udp', name: 'sflow daemon', service: 'sfacctd', redirected_service: 'sfacctd', persistence_timeout: 30 }, { port: 9092, protocol: 'tcp', name: 'kafka', service: 'kafka', redirected_service: 'kafka', persistence_timeout: 30 } ]

# Tier
default['redborder']['druid']['historical']['tier'] = 'default'
default['redborder']['druid']['historical']['maxsize'] = -1

# Virtual Ips
default['redborder']['manager']['virtual_ips'] = { internal: [{ service: 'postgresql' }], external: [{ service: 'webui', deps: ['nginx'] }, { service: 'f2k' }, { service: 'sfacctd' }, { service: 'kafka' }] }

default['redborder']['pending_changes'] = 0

# Priority Filter
default['redborder']['intrusion_incidents_priority_filter'] = 'high'
default['redborder']['vault_incidents_priority_filter'] = 'error'

# Save Secor S3 raw path
default['redborder']['manager']['s3rawpath'] = 'rbraw'
