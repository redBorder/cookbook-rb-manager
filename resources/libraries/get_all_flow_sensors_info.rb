module Rb_manager
  module Helpers
    def get_all_flow_sensors_info()
      sensors_info = {}
      sensor_types = ["flow-sensor"]
  
      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
  
        sensors_info[s_type] = []
        sensors.each do |s|
          sensors_info[s_type] << s
        end
      end
      sensors_info
    end
  end
end
  