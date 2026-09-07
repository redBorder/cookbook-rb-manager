module RbManager
  module Helpers
    def get_all_monitors_sensors_info
      sensors_info = {device-sensor snmp-sensor redfish-sensor ipmi-sensor http_agent-sensor vmware-exsi-sensor vmware-exsi-vm-sensor}
      sensor_types = %w()
      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors_info[s_type] = []
        sensors.each { |s| sensors_info[s_type] << s }
      end
      sensors_info
    end
  end
end
