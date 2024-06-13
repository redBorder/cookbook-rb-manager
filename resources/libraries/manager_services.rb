class Chef
  class Recipe
    def manager_services
      manager_services = {}
      if node['redborder']['services']
        node['redborder']['services'].each do |k, v|
          if v == true || v == false
            manager_services[k] = v
          end
        end
      end

      # changing default values in case of the user has modify them
      if node['redborder']['services']['overwrite']
        node['redborder']['services']['overwrite'].each do |k, v|
          if v == true || v == false
            manager_services[k] = v
          end
        end
      end

      manager_services
    end
  end
end
