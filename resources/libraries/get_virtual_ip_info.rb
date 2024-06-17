module RbManager
  module Helpers
    def get_virtual_ip_info(managers)
      virtual_ips = {}
      ip_regex = /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
      has_any_virtual_ip = false
      node['redborder']['manager']['virtual_ips'].each do |type, services|
        virtual_ips[type.to_s] = {}
        services.each do |service|
          begin
            virtual_dg = data_bag_item('rBglobal', "ipvirtual-#{type}-#{service['service']}")
          rescue
            virtual_dg = {}
          end
          hash = {}
          hash['ip'] = virtual_dg['ip']
          hash['loadbalance'] = (virtual_dg['loadbalance'].nil? ? true : virtual_dg['loadbalance'])
          hash['service'] = service['service']
          hash['enable'] = if virtual_dg['ip'] =~ ip_regex && !hash['ip'].nil?
                             true
                           else
                             false
                           end

          if hash['enable']
            hash['virtual'] = true
            hash['run_anywhere'] = true
            has_any_virtual_ip = true if hash['ip'] && manager_services[service['service']]
            hash['iface'] = node['redborder']['management_interface']
            if manager_services[service['service']]
              all_deps_enabled = true
              unless service['deps'].nil?
                service['deps'].each do |srv_dep|
                  all_deps_enabled = false if manager_services[srv_dep].nil? || manager_services[srv_dep] == false
                end
              end
              hash['enable'] = all_deps_enabled
            else
              hash['enable'] = false
            end
          else
            # The virtual ip is not valid or it has not been specified. We need to set at least one
            hash['virtual'] = false
            hash['run_anywhere'] = false
            nodeservice = nil
            managers.each do |m|
              hash['iface'] = node['redborder']['management_interface']
              run_anywhere_flag = false

              if m.name == node.name
                run_anywhere_flag = manager_services[service['service']]
              elsif !m['redborder'].nil? && !m['redborder']['manager'].nil? && !m['redborder']['manager']['services'].nil? && !m['redborder']['manager']['services']['current'].nil?
                run_anywhere_flag = m['redborder']['manager']['services']['current'][service['service']]
              end

              if run_anywhere_flag && !m['redborder']['manager'][hash['iface']].nil?
                nodeservice = m
                break
              end
            end

            if nodeservice.nil?
              managers.each do |m|
                hash['iface'] = node['redborder']['management_interface']
                run_anywhere_flag = false
                run_anywhere_flag = m['redborder']['manager']['services']['overwrite'][service['service']] unless m['redborder']['manager']['services']['overwrite'].nil?
                run_anywhere_flag = m['redborder']['manager']['services'][m['redborder']['manager']['mode']][service['service']] if run_anywhere_flag != true && !m['redborder']['manager']['services'][m['redborder']['manager']['mode']].nil?
                if run_anywhere_flag && !m['redborder']['manager'][hash['iface']].nil?
                  nodeservice = m
                  break
                end
              end
            end

            if !nodeservice.nil? && !nodeservice['redborder']['manager'][hash['iface']].nil?
              hash['virtual'] = false
              hash['ip'] = nodeservice['redborder']['manager'][hash['iface']]['ip']
              hash['physical_ip'] = hash['ip']
              hash['prefixlen'] = nodeservice['redborder']['manager'][hash['iface']]['prefixlen']
              hash['run_anywhere'] = true
            end
          end
          virtual_ips[type.to_s][service['service']] = hash
        end
      end

      [virtual_ips, has_any_virtual_ip]
    end

    def get_virtual_ips_per_ip_info(virtual_ips)
      virtual_ips_per_ip = {}
      virtual_ips.each do |_type, data|
        data.each.each do |_service, vi|
          if vi['ip']
            virtual_ips_per_ip[vi['ip']] = [] if virtual_ips_per_ip[vi['ip']].nil?
            virtual_ips_per_ip[vi['ip']] << vi
          end
        end
      end

      virtual_ips_per_ip
    end
  end
end
