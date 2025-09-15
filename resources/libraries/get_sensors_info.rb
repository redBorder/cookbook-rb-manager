module RbManager
  module Helpers
    def get_sensors_info
      sensors_info = {}
      sensor_types = %w(vault-sensor flow-sensor mse-sensor scanner-sensor meraki-sensor ale-sensor device-sensor
                        cisco-cloudproxy proxy-sensor arubacentral-sensor
                        ips-sensor intrusion-sensor intrusioncp-sensor ipsv2-sensor ipscp-sensor ipsg-sensor)
      locations = node['redborder']['locations']
      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors_info[s_type] = {}
        sensors.each do |s|
          # skip childs of proxy sensors
          if s['redborder']['parent_id']
            parent_sensor = search(:node, "sensor_id:#{s['redborder']['parent_id']}").first
            next if parent_sensor && parent_sensor.to_s.include?('proxy')
          end
          info = {}
          info['name'] = s.name
          info['ip'] = s['ipaddress']
          info['sensor_uuid'] = s['redborder']['sensor_uuid'] if s['redborder']['sensor_uuid']
          info['organization_uuid'] = s['redborder']['organization_uuid'] if s['redborder']['organization_uuid']
          info['megabytes_limit'] = s['redborder']['megabytes_limit'] if s['redborder']['megabytes_limit']
          info['index_partitions'] = s['redborder']['index_partitions'] if s['redborder']['index_partitions']
          info['index_replicas'] = s['redborder']['index_replicas'] if s['redborder']['index_replicas']
          info['sensors_mapping'] = s['redborder']['sensors_mapping'] if s['redborder']['sensors_mapping']
          info['locations'] = {}

          locations.each do |loc|
            next unless s['redborder'][loc]

            info['locations'][loc] = s['redborder'][loc]
          end

          sensors_info[s_type][s.name] = info
        end
      end

      sensors_info
    end

    def get_child_flow_sensors_info
      sensors_info = {}
      sensor_types = ['flow-sensor']

      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors_info[s_type] = []

        sensors.each do |s|
          next unless s['redborder'] && s['redborder']['parent_id']

          parent_sensor = search(:node, "sensor_id:#{s['redborder']['parent_id']}").first
          next unless parent_sensor && parent_sensor.to_s.include?('proxy') # Only if parent is a proxy
          parent_sensor_uuid = parent_sensor['redborder']['sensor_uuid']
          s.normal['redborder']['parent_proxy_uuid'] = parent_sensor_uuid

          sensors_info[s_type] << s
        end
      end

      sensors_info
    end

    # If you need to get sensors from the cluster but not from proxies and ips
    def get_cluster_sensors_info
      sensors_info = {}
      sensor_types = %w(flow-sensor scanner-sensor)

      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors_info[s_type] = []

        sensors.each do |s|
          if s['redborder']['parent_id']
            parent_sensor = search(:node, "sensor_id:#{s['redborder']['parent_id']}").first
            next if parent_sensor && parent_sensor.to_s.include?('proxy')
          end
          sensors_info[s_type] << s
        end
      end

      sensors_info
    end
  end
end
