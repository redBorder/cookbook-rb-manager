module RbManager
  module Helpers
    def get_sensors_all_info
      sensors_info = {}
      sensor_types = %w(ips-sensor ipsv2-sensor ipscp-sensor ipsg-sensor vault-sensor flow-sensor arubacentral-sensor mse-sensor meraki-sensor cisco-cloudproxy proxy-sensor scanner-sensor mse-sensor meraki-sensor ale-sensor cep-sensor device-sensor)

      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort  # get sensor where parent_id is nil or sensor at parent_id is not a proxy

        sensors_info[s_type] = []

        sensors.each do |sensor|
          if sensor['redborder_parent_id']
            parent_sensor = search(:node, "id:#{sensor['redborder_parent_id']}").first
            unless parent_sensor && parent_sensor['role']&.include?('proxy')
              sensors_info[s_type] << sensor
            end
          else
            sensors_info[s_type] << sensor
          end
        end
      end

      sensors_info
    end
  end
end
