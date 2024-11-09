module RbManager
  module Helpers
    def harddisk_services
      hd_services = {}

      root_dev = node['filesystem']['by_mountpoint']['/']

      hd_services_dev = { 'root' => root_dev, 'raw' => root_dev, 'aggregate' => root_dev }

      hd_services_size = Hash.new(0)
      hd_services_size_total = Hash.new(0)

      maxsize = {}
      hd_services_dev.each do |type, device|
        maxsize[type] = if node['filesystem'][device].nil?
                          300_000_000_000
                        else
                          filesystem_data = root_dev['kb_size']
                          size_kb = filesystem_data
                          size_bytes = size_kb.to_i * 1024
                          size_bytes -= 7 * 1024 * 1024 * 1024
                          [size_bytes, 0].max
                        end
      end

      node['redborder']['manager']['hd_services'].each do |s|
        if node['redborder']['services'][s[:name]]
          hd_services_size[hd_services_dev[s[:prefered]]] += s[:count]
        end
        hd_services_size_total[hd_services_dev[s[:prefered]]] += s[:count]
      end

      node['redborder']['manager']['hd_services'].each do |service|
        preferred_device = hd_services_dev[service[:prefered]]
        preferred_size = hd_services_size[preferred_device]
        total_size = hd_services_size_total[preferred_device]

        size = if preferred_size > 0
                 preferred_size
               else
                 total_size > 0 ? total_size : 1
               end

        service_count = service[:count].to_i
        max_preferred_size = maxsize[service[:prefered]].to_i
        hd_services[service[:name]] = ((service_count * max_preferred_size * 0.90) / size.to_f) / (1024 * 1024)
      end

      hd_services
    end
  end
end
