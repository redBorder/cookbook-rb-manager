class Chef
  class Recipe
    def get_managers_info()
      managers_info = {}
      manager_nodes = {}

      manager_nodes = search(:node, "recipes:rb-manager")
      manager_nodes.each do |mnode|
        name = mnode.name
        ip = mnode.ipaddress
        managers_info[name] = {}
        managers_info[name]["ip"] = ip
      end
 
      #The search function above is looking for rb-manager value in "Recipes" key instead run_list, for this reason
      #in the first execution the node data is not added to managers hash, so it will be checked now and added 
      #to managers hash.
      if !managers_info.key?(node["name"]) and node.recipe?("rb-manager")
        managers_info[node["name"]] = {}
        managers_info[node["name"]]["ip"] = node["ipaddress"]
      end
      return managers_info
    end
  end
end
