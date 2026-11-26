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
        overwrite_services(manager_services, node['redborder']['services']['overwrite'])
      end

      # redborder-webui's Manager#set_service writes admin overrides to
      # redborder.manager.services.overwrite (see redborder-webui's
      # app/models/manager.rb), not redborder.services.overwrite -- honor
      # it too, taking precedence since it's the most recent user change.
      manager_overwrite = node['redborder']['manager'] &&
                          node['redborder']['manager']['services'] &&
                          node['redborder']['manager']['services']['overwrite']
      if manager_overwrite
        overwrite_services(manager_services, manager_overwrite)
      end

      manager_services
    end

    # logstash has been replaced by redborder-vortex: an override saved for logstash
    # applies to redborder-vortex, unless redborder-vortex has its own override
    def overwrite_services(manager_services, overwrite)
      overwrite.each do |k, v|
        next unless v == true || v == false

        if k == 'logstash'
          next if overwrite.key?('redborder-vortex')

          k = 'redborder-vortex'
        end
        manager_services[k] = v
      end
    end
  end
end
