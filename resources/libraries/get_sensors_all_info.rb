module RbManager
  module Helpers
    def get_sensors_all_info
      sensors_info = {}
      sensor_types = %w(ips-sensor ipsv2-sensor ipscp-sensor ipsg-sensor vault-sensor flow-sensor arubacentral-sensor mse-sensor meraki-sensor cisco-cloudproxy proxy-sensor scanner-sensor mse-sensor meraki-sensor ale-sensor cep-sensor device-sensor snmp-sensor redfish-sensor ipmi-sensor http_agent-sensor trap-sensor vmware-exsi-sensor vmware-exsi-vm-sensor)

      sensor_types.each do |s_type|
        sensors_info[s_type] = get_sensors_with_role(s_type) # get all s_type's sensor
      end

      sensors_info
    end
  end
end
