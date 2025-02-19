module RbManager
  module Helpers
    def get_user_sensor_map
      sensor_map_hash = {}

      Chef::Role.list.each_key do |m_key|
        m = Chef::Role.load m_key
        next unless m.override_attributes['redborder'] && m.override_attributes['redborder']['sso_idp_organization_name']

        sensor_map_hash[m.override_attributes['redborder']['sso_idp_organization_name']] = m.name.delete_prefix('rBsensor-').to_i
      end

      sensor_map_str = sensor_map_hash.map { |name, sensor_id| "#{name}: #{sensor_id}" }.join("\n")
    end
  end
end
