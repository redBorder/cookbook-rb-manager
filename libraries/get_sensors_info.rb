module Rb_manager
  module Helpers
    def get_sensors_info()
      sensors_info = {}
      sensor_types = ["ips-sensor","ipsv2-sensor","ipscp-sensor","ipsg-sensor","flow-sensor","mse-sensor","meraki-sensor","cisco-cloudproxy","proxy-sensor"]
      locations = node["redborder"]["locations"]


      sensor_types.each do |s_type|
        sensors = search(:node, "role:#{s_type}").sort
        sensors.each do |s|
          info = {}
          info["name"] = s.name
          info["ip"] = s["ipaddress"]
          info["sensor_uuid"] = s["redborder"]["sensor_uuid"] if !s["redborder"]["sensor_uuid"].nil?
          info["organization_uuid"] = s["redborder"]["organization_uuid"] if !s["redborder"]["organization_uuid"].nil?
          info["megabytes_limit"] = s["redborder"]["megabytes_limit"] if !s["redborder"]["megabytes_limit"].nil?
          info["index_partitions"] = s["redborder"]["index_partitions"] if !s["redborder"]["index_partitions"].nil?
          info["index_replicas"] = s["redborder"]["index_replicas"] if !s["redborder"]["index_replicas"].nil?
          info["locations"] = {}
          locations.each do |loc|
            if !s["redborder"][loc].nil? and !s["redborder"][loc].empty?
              info["locations"][loc] = s["redborder"][loc]
            end

          end
      
          sensors_info[s_type] = {}
          sensors_info[s_type][s.name] = info
        end 
      end
      return sensors_info
    end
  end
end
