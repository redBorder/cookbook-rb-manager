module RbManager
  module Helpers
    def get_monitor_configuration
      monitor_config = []
      device_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*device*').sort
      snmp_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*snmp*').sort
      ipmi_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*ipmi*').sort
      redfish_sensors = search(:node, 'redborder_monitors:[* TO *] AND name:*redfish*').sort
      monitor_sensors = device_sensors + snmp_sensors + ipmi_sensors + redfish_sensors
      monitor_sensors.each do |node|
        monitors = node.normal['redborder']['monitors']
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
