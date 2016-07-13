module Rb_manager
  module Helpers
    def get_managers_info()
      managers_info = {}
      manager_nodes = {}
  
      manager_nodes = search(:node, "recipes:rb-manager").sort
 
      manager_nodes.each do |mnode|
        name = mnode.name
        ip = mnode["ipaddress"]
        services = []
        # add active services to array
        mnode_services = mnode["redborder"]["services"].to_h
        mnode_services.each do |service, service_status|
          services << service if service_status
        end
        managers_info[name] = {}
        managers_info[name]["ip"] = ip
        managers_info[name]["services"] = services
      end
 
      #The search function above is looking for rb-manager value in "Recipes" key instead run_list, for this reason
      #in the first execution the node data is not added to managers hash, so it will be checked now and added 
      #to managers hash
      if !managers_info.key?(node.name) and node.recipe?("rb-manager")
        name = node.name
        ip = node["ipaddress"]
        managers_info[name] = {}
        managers_info[name]["ip"] = ip
      end

      return managers_info
    end
  end
end
