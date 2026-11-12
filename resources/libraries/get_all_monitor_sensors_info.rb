module RbManager
  module Helpers
    def get_all_monitors_sensors_info
      sensors_info = {}
      sensor_types = %w(device-sensor snmp-sensor redfish-sensor ipmi-sensor http_agent-sensor vmware-exsi-sensor vmware-exsi-vm-sensor)
      sensor_types.each do |s_type|
        sensors_info[s_type] = get_sensors_with_role(s_type)
      end
      sensors_info
    end
  end
end
