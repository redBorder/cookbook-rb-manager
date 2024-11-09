module RbManager
  module Helpers
    def harddisk_services
      hd_services = {}
      root_dev_bytes = node['filesystem']['by_mountpoint']['/']['kb_size'].to_i * 1024
      node['redborder']['manager']['hd_services'].each do |service|
        service_name = service['name']
        service_count = service['count']
        porcentage = service_count / 100
        allocated_bytes = root_dev_bytes * porcentage
        hd_services[service_name] = allocated_bytes.to_i
      end
      hd_services # hard disk services sizes are pased in bytes
    end
  end
end
