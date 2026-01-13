module RbManager
  module Helpers
    def get_pipelines
      logstash_pipelines = []
      sensors = get_sensors_info()
      namespaces = get_namespaces()
      main_logstash = determine_main_logstash_node()
      monitor_sensor_in_proxy_nodes = find_sensor_in_proxy_nodes('device')
      flow_sensor_in_proxy_nodes = find_sensor_in_proxy_nodes('flow')
      monitor_config = get_monitor_configuration()
      has_device_sensors = !sensors['device-sensor'].nil? && !sensors['device-sensor'].empty?
      has_redfish_sensors = !sensors['redfish-sensor'].nil? && !sensors['redfish-sensor'].empty?
      has_snmp_sensors = !sensors['snmp-sensor'].nil? && !sensors['snmp-sensor'].empty?
      ips_sensors = get_all_ips_sensors_info
      has_ips_sensors = ips_sensors.any? { |_type, nodes| !nodes.empty? }

      logstash_pipelines.push('rbwindow-pipeline') if main_logstash == node.name
      logstash_pipelines.push('apstate-pipeline')
      logstash_pipelines.push('scanner-pipeline') unless sensors['scanner-sensor'].empty?
      logstash_pipelines.push('nmsp-pipeline') if main_logstash == node.name && !sensors['flow-sensor'].empty?
      logstash_pipelines.push('radius-pipeline') if main_logstash == node.name
      logstash_pipelines.push('netflow-pipeline') unless sensors['flow-sensor'].empty? && flow_sensor_in_proxy_nodes.empty?
      logstash_pipelines.push('sflow-pipeline') unless sensors['flow-sensor'].empty? && flow_sensor_in_proxy_nodes.empty?
      logstash_pipelines.push('meraki-pipeline') unless sensors['meraki-sensor'].empty?
      logstash_pipelines.push('monitor-pipeline') unless namespaces.empty?
      logstash_pipelines.push('intrusion-pipeline') if has_ips_sensors
      logstash_pipelines.push('druid-metrics-pipeline')

      if (sensors['ale-sensor'] && !sensors['ale-sensor'].empty?) ||
         (sensors['mse-sensor'] && !sensors['mse-sensor'].empty?) ||
         (sensors['flow-sensor'] && !sensors['flow-sensor'].empty?) ||
         (sensors['arubacentral-sensor'] && !sensors['arubacentral-sensor'].empty?)
        logstash_pipelines.push('location-pipeline')
        logstash_pipelines.push('mobility-pipeline')
      end

      logstash_pipelines.push('vault-pipeline')
      logstash_pipelines.push('malware-pipeline')
      logstash_pipelines.push('ips-pipeline') if has_ips_sensors

      if ((has_device_sensors || has_redfish_sensors) && monitor_config.include?('thermal')) || !monitor_sensor_in_proxy_nodes.empty?
        logstash_pipelines.push('redfish-pipeline')
      end
      if ((has_device_sensors || has_snmp_sensors) && monitor_config.include?('bulkstats_schema')) || !monitor_sensor_in_proxy_nodes.empty?
        logstash_pipelines.push('bulkstats-pipeline')
      end

      logstash_pipelines
    end

    # The main logstash is a node where both memcached and logstash are running or the first logstash node (order by name).
    # This main logasths node is gonna run the pipelines  rbwindow, location, mobility, nmsp, meraki and radius
    # Those pipelines should only run in one node (the main_logstash node) for now..
    def determine_main_logstash_node
      memcached_nodes = managers_per_service['memcached'].sort.uniq
      logstash_nodes = managers_per_service['logstash'].sort.uniq
      main_logstash_nodes = memcached_nodes & logstash_nodes
      main_logstash_nodes.first || logstash_nodes.first
    end
  end
end
