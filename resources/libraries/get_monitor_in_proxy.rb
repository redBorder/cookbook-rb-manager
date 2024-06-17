module RbManager
  module Helpers

    def find_monitor_sensor_in_proxy_nodes
      sensors_info = []
      sensor_types = ['proxy-sensor']

      sensor_types.each do |s_type|
        begin
          sensors = search(:node, "role:#{s_type}")
                    .map { |s| s.override['redborder']['sensors_mapping']['device'] }
                    .reject { |device| device.nil? || device.empty? }

          sensors_info.concat(sensors) unless sensors.empty?
        rescue NoMethodError
          sensors_info = []
        end
      end
      sensors_info
    end

  end
end
