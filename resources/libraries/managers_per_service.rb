class Chef
  class Recipe
    def managers_per_service
      services = node['redborder']['services']
      cluster_info = node['redborder']['cluster_info']
      cluster_services = {}

      services.each do |serv, _status|
        cluster_services[serv] = []
        cluster_info.each do |manager, info|
          if info['services'] && info['services'].include?(serv)
            cluster_services[serv] << manager
          end
        end
      end

      cluster_services
    end
  end
end
