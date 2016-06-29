default["redborder"]["kafka"]["memory"] = "512"
default["redborder"]["kafka"]["logdir"] = "/var/log/kafka"
default["redborder"]["zk_hosts"] = ["localhost"]
default["redborder"]["memory"] = "512"
default["redborder"]["managers_list"] = ["localhost"]

default["redborder"]["manager"]["services"] = {}
default["redborder"]["manager"]["services"]["chef-client"]         = false
default["redborder"]["manager"]["services"]["keepalived"]          = false
default["redborder"]["manager"]["services"]["druid_coordinator"]   = false
default["redborder"]["manager"]["services"]["druid_realtime"]      = false
default["redborder"]["manager"]["services"]["druid_historical"]    = false
default["redborder"]["manager"]["services"]["druid_broker"]        = false
default["redborder"]["manager"]["services"]["druid_overlord"]      = false
default["redborder"]["manager"]["services"]["druid_middleManager"] = false
default["redborder"]["manager"]["services"]["kafka"]               = false
default["redborder"]["manager"]["services"]["zookeeper"]           = false
default["redborder"]["manager"]["services"]["zookeeper2"]          = false
default["redborder"]["manager"]["services"]["rb-webui"]            = false
default["redborder"]["manager"]["services"]["postgresql"]          = false
default["redborder"]["manager"]["services"]["nginx"]               = false
default["redborder"]["manager"]["services"]["opscode-erchef"]      = false
default["redborder"]["manager"]["services"]["opscode-expander"]    = false
default["redborder"]["manager"]["services"]["opscode-solr4"]       = false
default["redborder"]["manager"]["services"]["opscode-chef-mover"]  = false
default["redborder"]["manager"]["services"]["oc_bifrost"]          = false
default["redborder"]["manager"]["services"]["oc_id"]               = false
default["redborder"]["manager"]["services"]["bookshelf"]           = false
default["redborder"]["manager"]["services"]["rabbitmq"]            = false
default["redborder"]["manager"]["services"]["redis_lb"]            = false
default["redborder"]["manager"]["services"]["cep"]                 = false
default["redborder"]["manager"]["services"]["iptables"]            = false
default["redborder"]["manager"]["services"]["memcached"]           = false
default["redborder"]["manager"]["services"]["rb-monitor"]          = false
default["redborder"]["manager"]["services"]["secor"]               = false



