module RbManager
  module Helpers
    def get_monitor_configuration
      monitor_config = []
      monitor_roles = %w(device-sensor snmp-sensor ipmi-sensor redfish-sensor http_agent-sensor vmware-exsi-sensor vmware-exsi-vm-sensor)
      monitor_sensors = monitor_roles.flat_map { |role| get_sensors_with_role(role) }
      monitor_sensors.each do |sensor|
        next unless sensor['redborder'] && sensor['redborder']['monitors']

        monitors = sensor.normal['redborder']['monitors'] || []
        monitors.each do |monitor|
          if monitor['name'] == 'bulkstats_schema' || monitor['name'] == 'thermal'
            monitor_config << monitor['name']
          end
        end
      end
      monitor_config
    end
  end
end
