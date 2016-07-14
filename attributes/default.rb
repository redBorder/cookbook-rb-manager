default["redborder"]["kafka"]["memory"] = "512"
default["redborder"]["kafka"]["logdir"] = "/var/log/kafka"
default["redborder"]["zk_hosts"] = ["localhost"]
default["redborder"]["memory"] = "512"

# default attributes for managers_info, it would be rewriten with the cluster config
default["redborder"]["managers_info"] = {}
default["redborder"]["managers_info"][node["hostname"]] = {}
default["redborder"]["managers_info"][node["hostname"]]["ip"] = node["ipaddress"]



default["redborder"]["managers_list"] = ["localhost"]
default["redborder"]["zookeeper_hosts"] = []

default["redBorder"]["memory_services"] = [
                                            {"name" => "zookeeper", "count" => 40, "limit" => 2048},
                                            {"name" => "kafka", "count" => 120}
                                          ]
default["redborder"]["memory_assigned"] = {}

default["redborder"]["services_groups"]["example"] = ["zookeeper", "kafka", "chef-client"]

default["redborder"]["services"] = {}
default["redborder"]["services"]["chef-client"]         = true
default["redborder"]["services"]["keepalived"]          = false
default["redborder"]["services"]["druid_coordinator"]   = false
default["redborder"]["services"]["druid_realtime"]      = false
default["redborder"]["services"]["druid_historical"]    = false
default["redborder"]["services"]["druid_broker"]        = false
default["redborder"]["services"]["druid_overlord"]      = false
default["redborder"]["services"]["druid_middleManager"] = false
default["redborder"]["services"]["kafka"]               = false
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

