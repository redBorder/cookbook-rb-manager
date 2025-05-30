module RbManager
  module Helpers
    def get_all_ips_sensors_info
      sensors_info = {}
      sensor_types = %w(ips-sensor ipsv2-sensor ipscp-sensor ipsg-sensor intrusion-sensor intrusioncp-sensor)
      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors_info[s_type] = []
        sensors.each { |s| sensors_info[s_type] << s }
      end
      sensors_info
    end
  end
end
