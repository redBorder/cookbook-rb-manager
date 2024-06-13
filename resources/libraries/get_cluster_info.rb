module RbManager
  module Helpers
    def get_cluster_info
      cluster_info = {}
      manager_nodes = search(:node, 'recipes:rb-manager').sort

      # The search function above is looking for rb-manager value in 'Recipes' key instead run_list, for this reason
      # in the first execution the node data is not added to managers hash, so it will be checked now and added
      # to managers array
      if !cluster_info.key?(node.name) && node.recipe?('rb-manager') && !manager_nodes.include?(node)
        manager_nodes << node
      end

      manager_nodes.each do |mnode|
        name = mnode.name
        mnode.normal['rb_time'] = Time.now.to_i if mnode['rb_time'].nil?
        rb_time = mnode['rb_time']
        services = []
        # add active services to array
        mnode_services = mnode['redborder']['services'].to_h
        mnode_services.each do |service, service_status|
          services << service if service_status
        end
        cluster_info[name] = {}
        cluster_info[name]['name'] = name
        cluster_info[name]['ip'] = mnode['ipaddress']
        cluster_info[name]['rb_time'] = rb_time
        cluster_info[name]['services'] = services
      end

      cluster_info = cluster_info.sort { |a, b| (a[1]['rb_time'] || 999999999999999999999) <=> (b[1]['rb_time'] || 999999999999999999999) }.to_h
    end
  end
end
