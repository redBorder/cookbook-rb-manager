#Default attributes

#kafka
default["redborder"]["kafka"]["port"] = 9092
default["redborder"]["kafka"]["logdir"] = "/var/log/kafka"
default["redborder"]["kafka"]["host_index"] = 0

#zookeeper
default["redborder"]["zookeeper"]["zk_hosts"] = "localhost:2181"
default["redborder"]["zookeeper"]["port"] = 2181

# hard disk
default["redborder"]["manager"]["data_dev"]              = {}
default["redborder"]["manager"]["data_dev"]["root"]      = "/dev/mapper/VolGroup-lv_root"
default["redborder"]["manager"]["data_dev"]["raw"]       = "/dev/mapper/vg_rbdata-lv_raw"
default["redborder"]["manager"]["data_dev"]["aggregate"] = "/dev/mapper/vg_rbdata-lv_aggregated"
default["redborder"]["manager"]["hd_services"] = [
                                                   {"name" => "kafka" , "count" => 5 , "prefered" => "aggregate"},
                                                   {"name" => "zookeeper" , "count" => 1 , "prefered" => "aggregate"},
                                                   {"name" => "riak" , "count" => 50, "prefered" => "raw"},
                                                   {"name" => "druid_historical", "count" => 50, "prefered" => "raw"},
                                                   {"name" => "hadoop_datanode" , "count" => 50, "prefered" => "raw"}
                                                 ]                                                 

default["redborder"]["manager"]["hd_services_current"] = {}


# memory
default["redborder"]["memory_services"]    = {}
#default["redborder"]["memory_services"]["kafka"]     = {"count" => 150, "memory" => 0,"max_limit" => 2097152}
default["redborder"]["memory_services"]["kafka"]     = {"count" => 150, "memory" => 0,"max_limit" => 524288}
default["redborder"]["memory_services"]["zookeeper"] = {"count" => 20, "memory" => 0}
default["redborder"]["memory_services"]["chef-client"] = {"count" => 10, "memory" => 0}
default["redborder"]["memory_services"]["keepalived"] = {"count" => 10, "memory" => 0}
default["redborder"]["memory_services"]["druid_coordinator"] = {"count" => 10, "memory" => 0}
 

# default attributes for managers_info, it would be rewriten with the cluster config
default["redborder"]["cluster_info"] = {}
default["redborder"]["cluster_info"][node["hostname"]] = {}
default["redborder"]["cluster_info"][node["hostname"]]["ip"] = node["ipaddress"]

default["redborder"]["managers_per_services"] = {}

default["redborder"]["managers_list"] = ["localhost"]
default["redborder"]["zookeeper_hosts"] = []

default["redborder"]["memory_assigned"] = {}

default["redborder"]["services_groups"]["example"] = ["zookeeper", "kafka", "chef-client"]

default["redborder"]["services"] = {}
default["redborder"]["services"]["chef-client"]         = true
default["redborder"]["services"]["keepalived"]          = true
default["redborder"]["services"]["druid_coordinator"]   = true
default["redborder"]["services"]["druid_realtime"]      = false
default["redborder"]["services"]["druid_historical"]    = false
default["redborder"]["services"]["druid_broker"]        = false
default["redborder"]["services"]["druid_overlord"]      = false
default["redborder"]["services"]["druid_middleManager"] = false
default["redborder"]["services"]["kafka"]               = true
default["redborder"]["services"]["zookeeper"]           = false
default["redborder"]["services"]["rb-webui"]            = false
default["redborder"]["services"]["postgresql"]          = false
default["redborder"]["services"]["nginx"]               = false
default["redborder"]["services"]["opscode-erchef"]      = false
default["redborder"]["services"]["opscode-expander"]    = false
default["redborder"]["services"]["opscode-solr4"]       = false
default["redborder"]["services"]["opscode-chef-mover"]  = false
default["redborder"]["services"]["oc_bifrost"]          = false
default["redborder"]["services"]["oc_id"]               = false
default["redborder"]["services"]["bookshelf"]           = false
default["redborder"]["services"]["rabbitmq"]            = false
default["redborder"]["services"]["redis_lb"]            = false
default["redborder"]["services"]["cep"]                 = false
default["redborder"]["services"]["iptables"]            = false
default["redborder"]["services"]["memcached"]           = false
default["redborder"]["services"]["rb-monitor"]          = false
default["redborder"]["services"]["secor"]               = false


