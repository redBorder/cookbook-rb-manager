module RbManager
  module Helpers
    def get_pipelines
      vortex_pipelines = []
      sensors = get_sensors_info()
      main_vortex = determine_main_vortex_node()
      monitor_sensor_in_proxy_nodes = find_sensor_in_proxy_nodes('device')
      flow_sensor_in_proxy_nodes = find_sensor_in_proxy_nodes('flow')
      monitor_config = get_monitor_configuration()
      has_device_sensors = !sensors['device-sensor'].nil? && !sensors['device-sensor'].empty?
      has_redfish_sensors = !sensors['redfish-sensor'].nil? && !sensors['redfish-sensor'].empty?
      has_snmp_sensors = !sensors['snmp-sensor'].nil? && !sensors['snmp-sensor'].empty?
      has_trap_sensors = !get_sensors_with_role('trap-sensor').empty?
      ips_sensors = get_all_ips_sensors_info
      has_ips_sensors = ips_sensors.any? { |_type, nodes| !nodes.empty? }

      vortex_pipelines.push('rbwindow-pipeline') if main_vortex == node.name
      vortex_pipelines.push('apstate-pipeline')
      vortex_pipelines.push('scanner-pipeline') unless sensors['scanner-sensor'].empty?
      vortex_pipelines.push('nmsp-pipeline') if main_vortex == node.name && !sensors['flow-sensor'].empty?
      vortex_pipelines.push('radius-pipeline') if main_vortex == node.name
      vortex_pipelines.push('netflow-pipeline') unless sensors['flow-sensor'].empty? && flow_sensor_in_proxy_nodes.empty?
      vortex_pipelines.push('sflow-pipeline') unless sensors['flow-sensor'].empty? && flow_sensor_in_proxy_nodes.empty?
      vortex_pipelines.push('meraki-pipeline') unless sensors['meraki-sensor'].empty?
      vortex_pipelines.push('monitor-pipeline')
      vortex_pipelines.push('intrusion-pipeline') if has_ips_sensors
      vortex_pipelines.push('druid-metrics-pipeline')
      vortex_pipelines.push('trap-pipeline') if has_trap_sensors || has_ips_sensors

      if (sensors['ale-sensor'] && !sensors['ale-sensor'].empty?) ||
         (sensors['mse-sensor'] && !sensors['mse-sensor'].empty?) ||
         (sensors['flow-sensor'] && !sensors['flow-sensor'].empty?) ||
         (sensors['arubacentral-sensor'] && !sensors['arubacentral-sensor'].empty?)
        vortex_pipelines.push('location-pipeline')
        vortex_pipelines.push('mobility-pipeline')
      end

      vortex_pipelines.push('vault-pipeline')
      vortex_pipelines.push('malware-pipeline')
      vortex_pipelines.push('ips-pipeline') if has_ips_sensors

      if ((has_device_sensors || has_redfish_sensors) && monitor_config.include?('thermal')) || !monitor_sensor_in_proxy_nodes.empty?
        vortex_pipelines.push('redfish-pipeline')
      end
      if ((has_device_sensors || has_snmp_sensors) && monitor_config.include?('bulkstats_schema')) || !monitor_sensor_in_proxy_nodes.empty?
        vortex_pipelines.push('bulkstats-pipeline')
      end

      vortex_pipelines
    end

    # The main vortex is a node where both memcached and redborder-vortex are running or the first vortex node (order by name).
    # This main vortex node is gonna run the pipelines  rbwindow, location, mobility, nmsp, meraki and radius
    # Those pipelines should only run in one node (the main_vortex node) for now..
    def determine_main_vortex_node
      memcached_nodes = managers_per_service['memcached'].sort.uniq
      vortex_nodes = managers_per_service['redborder-vortex'].sort.uniq
      main_vortex_nodes = memcached_nodes & vortex_nodes
      main_vortex_nodes.first || vortex_nodes.first
    end
  end
end
