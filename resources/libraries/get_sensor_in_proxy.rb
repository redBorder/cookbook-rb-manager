# frozen_string_literal: true

module RbManager
  module Helpers
    def find_sensor_in_proxy_nodes(sensor_type)
      sensors_info = []
      begin
        sensors = search(:role, 'run_list:role\[proxy-sensor\]')
                  .map { |role| role.override_attributes['redborder']['sensors_mapping'][sensor_type.to_s] }
                  .reject { |s_type| s_type.nil? || s_type.empty? }
        sensors_info.concat(sensors) unless sensors.empty?
      rescue NoMethodError
        sensors_info = []
      end
      sensors_info
    end
  end
end
