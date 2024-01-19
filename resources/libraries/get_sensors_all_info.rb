module Rb_manager
  module Helpers
    def get_sensors_all_info()
      sensors_info = {}
      sensor_types = ["ips-sensor","ipsv2-sensor","ipscp-sensor","ipsg-sensor","vault-sensor","flow-sensor","arubacentral-sensor","mse-sensor","meraki-sensor","cisco-cloudproxy","proxy-sensor","scanner-sensor","mse-sensor","meraki-sensor","ale-sensor","cep-sensor","device-sensor"]

      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type} AND -redborder_parent_id:*?").sort  #get sensor where parent_id is nil

        sensors_info[s_type] = []
        sensors.each do |s|
          sensors_info[s_type] << s
        end
      end
      sensors_info
    end
  end
end
