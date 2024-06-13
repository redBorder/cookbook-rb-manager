module RbManager
  module Helpers
    def harddisk_services
      hd_services = {}

      root_dev = node['redborder']['manager']['data_dev']['root']
      raw_dev = node['redborder']['manager']['data_dev']['raw']
      aggregate_dev = node['redborder']['manager']['data_dev']['aggregate']

      root_dev = node['filesystem'].keys.first if node['filesystem'][root_dev].nil?
      if node['filesystem'][raw_dev].nil? && node['filesystem'][aggregate_dev].nil?
        raw_dev = root_dev
        aggregate_dev = root_dev
      elsif node['filesystem'][raw_dev].nil?
        raw_dev = aggregate_dev
      elsif node['filesystem'][aggregate_dev].nil?
        aggregate_dev = raw_dev
      end

      hd_services_dev = {}
      hd_services_dev['root'] = root_dev
      hd_services_dev['raw'] = raw_dev
      hd_services_dev['aggregate'] = aggregate_dev

      hd_services_size = {}
      hd_services_size[root_dev] = 0
      hd_services_size[raw_dev] = 0
      hd_services_size[aggregate_dev] = 0

      hd_services_size_total = {}
      hd_services_size_total[root_dev] = 0
      hd_services_size_total[raw_dev] = 0
      hd_services_size_total[aggregate_dev] = 0

      maxsize = {}
      hd_services_dev.each do |type, device|
        maxsize[type] = if node['filesystem'][device].nil?
                          300_000_000_000
                        else
                          filesystem_data = node['filesystem'][device]
                          root_device = hd_services_dev['root']
                          size_kb = filesystem_data['kb_size'] || node['filesystem'][root_device]['kb_size']
                          size_bytes = size_kb.to_i * 1024
                          size_bytes -= 7 * 1024 * 1024 * 1024 if device == root_device
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
