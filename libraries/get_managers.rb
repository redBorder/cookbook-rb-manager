module Rb_manager
  module Helpers
    def get_managers_info()
      managers_info = {}
      manager_nodes = {}
  
      manager_nodes = search(:node, "recipes:rb-manager")
      manager_nodes.each do |mnode|
        hostname = mnode["hostname"]
        ip = mnode["ipaddress"]
        managers_info[hostname] = {}
        managers_info[hostname]["ip"] = ip
      end
  
      #The search function above is looking for rb-manager value in "Recipes" key instead run_list, for this reason
      #in the first execution the node data is not added to managers hash, so it will be checked now and added 
      #to managers hasha

      if !managers_info.key?(node["hostname"]) and node.recipe?("rb-manager")
        hostname = node["hostname"]
        ip = node["ipaddress"]
        managers_info[hostname] = {}
        managers_info[hostname]["ip"] = ip
      end

      return managers_info
    end
  end
end
