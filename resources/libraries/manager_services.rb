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

      # redborder-webui's Manager#set_service writes admin overrides to
      # redborder.manager.services.overwrite (see redborder-webui's
      # app/models/manager.rb), not redborder.services.overwrite -- honor
      # it too, taking precedence since it's the most recent user change.
      manager_overwrite = node['redborder']['manager'] &&
                           node['redborder']['manager']['services'] &&
                           node['redborder']['manager']['services']['overwrite']
      if manager_overwrite
        manager_overwrite.each do |k, v|
          if v == true || v == false
            manager_services[k] = v
          end
        end
      end

      manager_services
    end
  end
end
