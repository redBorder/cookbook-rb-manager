# general
default['redborder']['cdomain'] = 'redborder.cluster'
default['redborder']['organization_uuid'] = nil
default['redborder']['organizations'] = []
default['redborder']['locations'] = %w(namespace namespace_uuid organization organization_uuid service_provider service_provider_uuid deployment deployment_uuid market market_uuid campus campus_uuid building building_uuid floor floor_uuid)

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

# memcached
default['redborder']['memcached']['elasticache'] = false
default['redborder']['memcached']['server_list'] = []
default['redborder']['memcached']['options'] = ''
default['redborder']['memcached']['port'] = 11211

# hadoop
default['redborder']['hadoop']['containersMemory'] = 2048
# samza
default['redborder']['samza']['num_containers'] = 1
default['redborder']['samza']['memory_per_container'] = 2560
# riak

# hard disk
default['redborder']['manager']['data_dev'] = {}
default['redborder']['manager']['data_dev']['root'] = '/dev/mapper/VolGroup-lv_root'
default['redborder']['manager']['data_dev']['raw'] = '/dev/mapper/vg_rbdata-lv_raw'
default['redborder']['manager']['data_dev']['aggregate'] = '/dev/mapper/vg_rbdata-lv_aggregated'
default['redborder']['manager']['hd_services'] = [
                                                   { 'name': 'kafka', 'count': 5, 'prefered': 'aggregate' },
                                                   { 'name': 'zookeeper', 'count': 1, 'prefered': 'aggregate' },
                                                   { 'name': 'riak', 'count': 50, 'prefered': 'raw' },
                                                   { 'name': 'druid_historical', 'count': 50, 'prefered': 'raw' },
                                                   { 'name': 'hadoop_datanode', 'count': 50, 'prefered': 'raw' },
                                                 ]

default['redborder']['manager']['hd_services_current'] = {}

# memory
default['redborder']['memory_services'] = {}
default['redborder']['memory_services']['kafka'] = { 'count': 150, 'memory': 0, 'max_limit': 524288 }
default['redborder']['memory_services']['zookeeper'] = { 'count': 20, 'memory': 0 }
default['redborder']['memory_services']['chef-client'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['keepalived'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['druid-coordinator'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['druid-overlord'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['druid-historical'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['druid-broker'] = { 'count' => 10, 'memory' => 0 }
default['redborder']['memory_services']['druid-middlemanager'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['druid-realtime'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['http2k'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['chef-server'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['postgresql'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['redborder-postgresql'] = { 'count': 5, 'memory': 0 }
default['redborder']['memory_services']['mongodb'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['memcached'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['hadoop-nodemanager'] = { 'count': 50, 'memory': 0 }
default['redborder']['memory_services']['hadoop-resourcemanager'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['snmp'] = { 'count': 5, 'memory': 0, 'max_limit': 10000 }
default['redborder']['memory_services']['redborder-monitor'] = { 'count': 5, 'memory': 0, 'max_limit': 20000 }
default['redborder']['memory_services']['rb-logstatter'] = { 'count': 5, 'memory': 0, 'max_limit': 20000 }
default['redborder']['memory_services']['rb-arubacentral'] = { 'count': 5, 'memory': 0, 'max_limit': 20000 }
default['redborder']['memory_services']['webui'] = { 'count': 40, 'memory': 0 }
default['redborder']['memory_services']['f2k'] = { 'count': 40, 'memory': 0 }
default['redborder']['memory_services']['redborder-nmsp'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['n2klocd'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['redborder-cep'] = { 'count': 10, 'memory': 0 }
default['redborder']['memory_services']['rb-aioutliers'] = { 'count': 10, 'memory': 0 }

# exclude mem services, setting memory to 0 for each.
default['redborder']['excluded_memory_services'] = %w(chef-client)

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
                                                    postgresql redborder-postgresql nginx webui druid-broker
                                                    druid-historical druid-realtime druid-coordinator f2k
                                                    redborder-monitor pmacct redborder-dswatcher
                                                    redborder-events-counter http2k)

default['redborder']['services_group']['custom'] = []
default['redborder']['services_group']['core'] = %w(consul zookeeper druid-coordinator druid-overlord hadoop-resourcemanager) # consul server
default['redborder']['services_group']['chef'] = %w(chef-server)
default['redborder']['services_group']['kafka'] = %w(kafka)
default['redborder']['services_group']['historical'] = %w(druid-historical)
default['redborder']['services_group']['middlemanager'] = %w(druid-middlemanager)
default['redborder']['services_group']['broker'] = %w(druid-broker)
default['redborder']['services_group']['http2k'] = %w(http2k)
default['redborder']['services_group']['samza'] = %w(hadoop-nodemanager)
default['redborder']['services_group']['webui'] = %w(nginx webui)
default['redborder']['services_group']['f2k'] = %w(f2k)
default['redborder']['services_group']['s3'] = %w(nginx s3)
default['redborder']['services_group']['postgresql'] = %w(postgresql redborder-postgresql)

default['redborder']['services'] = {}
default['redborder']['services']['chef-client']               = true
default['redborder']['services']['chef-server']               = false
default['redborder']['services']['consul']                    = false
default['redborder']['services']['consul-client']             = false
default['redborder']['services']['keepalived']                = false
default['redborder']['services']['druid-coordinator']         = false
default['redborder']['services']['druid-realtime']            = false
default['redborder']['services']['druid-historical']          = false
default['redborder']['services']['druid-broker']              = false
default['redborder']['services']['druid-overlord']            = false
default['redborder']['services']['druid-middlemanager']       = false
default['redborder']['services']['kafka']                     = false
default['redborder']['services']['zookeeper']                 = false
default['redborder']['services']['http2k']                    = false
default['redborder']['services']['webui']                     = false
default['redborder']['services']['postgresql']                = false
default['redborder']['services']['redborder-postgresql']      = false
default['redborder']['services']['nginx']                     = false
default['redborder']['services']['redborder-cep']             = false
default['redborder']['services']['rb-aioutliers']             = false
default['redborder']['services']['rb-logstatter']             = true
default['redborder']['services']['rb-arubacentral']           = false
default['redborder']['services']['memcached']                 = true
default['redborder']['services']['rb-monitor']                = false
default['redborder']['services']['secor']                     = false
default['redborder']['services']['s3']                        = false
default['redborder']['services']['mongodb']                   = false
default['redborder']['services']['hadoop-nodemanager']        = false
default['redborder']['services']['hadoop-resourcemanager']    = false
default['redborder']['services']['redborder-monitor']         = true
default['redborder']['services']['redborder-scanner']         = false
default['redborder']['services']['snmp']                      = true
default['redborder']['services']['f2k']                       = false
default['redborder']['services']['logstash']                  = false
default['redborder']['services']['pmacct']                    = false
default['redborder']['services']['redborder-dswatcher']       = false
default['redborder']['services']['redborder-events-counter']  = false
default['redborder']['services']['rsyslog']                   = true
default['redborder']['services']['redborder-nmsp']            = false
default['redborder']['services']['redborder-ale']             = false
default['redborder']['services']['n2klocd']                   = false
default['redborder']['services']['radiusd']                   = false
default['redborder']['services']['postfix']                   = true
default['redborder']['services']['keepalived']                = false

default['redborder']['systemdservices']['chef-client']            = ['chef-client']
default['redborder']['systemdservices']['chef-server']            = ['opscode-erchef']
default['redborder']['systemdservices']['consul']                 = ['consul']
default['redborder']['systemdservices']['consul-client']          = ['consul']
default['redborder']['systemdservices']['druid-realtime']         = ['druid-realtime']
default['redborder']['systemdservices']['druid-coordinator']      = ['druid-coordinator']
default['redborder']['systemdservices']['druid-historical']       = ['druid-historical']
default['redborder']['systemdservices']['druid-broker']           = ['druid-broker']
default['redborder']['systemdservices']['kafka']                  = ['kafka']
default['redborder']['systemdservices']['zookeeper']              = ['zookeeper']
default['redborder']['systemdservices']['webui']                  = ['webui']
default['redborder']['systemdservices']['postgresql']             = ['postgresql']
default['redborder']['systemdservices']['redborder-postgresql']   = ['redborder-postgresql']
default['redborder']['systemdservices']['nginx']                  = ['nginx']
default['redborder']['systemdservices']['redborder-cep']          = ['redborder-cep']
default['redborder']['systemdservices']['rb-aioutliers']          = ['rb-aioutliers']
default['redborder']['systemdservices']['rb-logstatter']          = ['rb-logstatter']
default['redborder']['systemdservices']['rb-arubacentral']        = ['rb-arubacentral']
default['redborder']['systemdservices']['memcached']              = ['memcached']
default['redborder']['systemdservices']['s3']                     = ['minio']
default['redborder']['systemdservices']['mongodb']                = ['mongod']
default['redborder']['systemdservices']['redborder-monitor']      = ['redborder-monitor']
default['redborder']['systemdservices']['redborder-scanner']      = ['redborder-scanner']
default['redborder']['systemdservices']['snmp']                   = ['snmpd']
default['redborder']['systemdservices']['f2k']                    = ['f2k']
default['redborder']['systemdservices']['logstash']               = ['logstash']
default['redborder']['systemdservices']['pmacct']                 = ['sfacctd']
default['redborder']['systemdservices']['redborder-dswatcher']    = ['redborder-dswatcher']
default['redborder']['systemdservices']['redborder-events-counter'] = ['redborder-events-counter']
default['redborder']['systemdservices']['http2k']                 = ['http2k']
default['redborder']['systemdservices']['rsyslog']                = ['rsyslog']
default['redborder']['systemdservices']['redborder-nmsp']         = ['redborder-nmsp']
default['redborder']['systemdservices']['redborder-ale']          = ['redborder-ale']
default['redborder']['systemdservices']['n2klocd']                = ['n2klocd']
default['redborder']['systemdservices']['radiusd']                = ['radiusd']
default['redborder']['systemdservices']['postfix']                = ['postfix']
default['redborder']['systemdservices']['keepalived']             = ['keepalived']

default['redborder']['manager']['balanced'] = [ { port: 443, protocol: 'tcp', name: 'redborder webui', service: 'webui', redirected_service: 'nginx', persistence_timeout: 9600 }, { port: 2055, protocol: 'udp', name: 'netflow,ipfix/sflow daemon', service: 'f2k', redirected_service: 'f2k', persistence_timeout: 30 }, { port: 6343, protocol: 'udp', name: 'sflow daemon', service: 'sfacctd', redirected_service: 'sfacctd', persistence_timeout: 30 }, { port: 9092, protocol: 'tcp', name: 'kafka', service: 'kafka', redirected_service: 'kafka', persistence_timeout: 30 } ]

# Tier
default['redborder']['druid']['historical']['tier'] = 'default'
default['redborder']['druid']['historical']['maxsize'] = -1

# Virtual Ips
default['redborder']['manager']['virtual_ips'] = { external: [ { service: 'webui', deps: ['nginx'] }, { service: 'f2k' }, { service: 'sfacctd' }, { service: 'kafka' } ] }

# Realtime
default['redborder']['druid']['realtime']['partition_num'] = 0

default['redborder']['pending_changes'] = 0
