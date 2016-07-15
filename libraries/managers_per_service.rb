class Chef
  class Recipe
    def managers_per_service()
      # get managers with zookeeper

#managers_with_zookeeper = []
# 
#node["redborder"]["managers_info"].each do |mgr, m_val|
#  managers_with_zookeeper << mgr if m_val["services"].to_a.include?("zookeeper")
#end
#node.default["redborder"]["zookeeper_hosts"] = managers_with_zookeeper
    services = node["redborder"]["services"]
    cluster_info = node["redborder"]["cluster_info"] 
    cluster_services = {}

    services.each do |serv, status|
      cluster_services[serv] = []
      cluster_info.each do |manager, info|
        if info["services"].include?(serv)
         cluster_services[serv] << manager 
        end
      end
    end
    return cluster_services
    end
  end
end
