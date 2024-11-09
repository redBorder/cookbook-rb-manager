module RbManager
  module Helpers
    def harddisk_services
      hd_services = {}
      root_dev_bytes = node['filesystem']['by_mountpoint']['/']['kb_size'].to_i * 1024
      
      node['redborder']['manager']['hd_services'].each do |service|
        service_name = service['name']
        service_count = service['count']

        allocated_bytes = if service_count > 1
                            (root_dev_bytes * 0.4).to_f
                          else
                            (root_dev_bytes * 0.01).to_f
                          end

        hd_services[service_name] = allocated_bytes
      end

      hd_services
    end
  end
end
