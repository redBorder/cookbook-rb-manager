module RbManager
  module Helpers
    def harddisk_services
      hd_services = {}
      root_dev_kb = node['filesystem']['by_mountpoint']['/']['kb_size']
      size_bytes = root_dev_kb.to_i * 1024
      size_bytes -= 7 * 1024 * 1024 * 1024
      maxsize = size_bytes

      hd_services_dev = node['redborder']['manager']['hd_services'].map do |service|
        {
          name: service[:name],
          count: node['redborder']['services'][service[:name]] ? service[:count] + 1 : service[:count],
        }
      end

      hd_services_dev.each do |service|
        service_count = service[:count].to_f / 100
        hd_services[service[:name]] = service_count * maxsize * 0.90
      end

      hd_services # hard disk services sizes are pased in bytes
    end
  end
end
