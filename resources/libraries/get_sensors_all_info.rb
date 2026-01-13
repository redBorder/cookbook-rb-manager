module RbManager
  module Helpers
    def get_sensors_all_info
      sensors_info = {}
      sensor_types = %w(ips-sensor ipsv2-sensor ipscp-sensor ipsg-sensor vault-sensor flow-sensor arubacentral-sensor mse-sensor meraki-sensor cisco-cloudproxy proxy-sensor scanner-sensor mse-sensor meraki-sensor ale-sensor cep-sensor device-sensor snmp-sensor redfish-sensor ipmi-sensor)

      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort  # get all s_type's sensor

        sensors_info[s_type] = []

        sensors.each do |sensor|
          sensors_info[s_type] << sensor
        end
      end

      sensors_info
    end
  end
end
