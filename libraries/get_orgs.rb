module Rb_manager
  module Helpers
    def get_orgs()

      Chef::Role.list.keys.each do |m_key|
        m = Chef::Role.load m_key
        if !m.override_attributes["redBorder"].nil? and !m.override_attributes["redBorder"]["organization_uuid"].nil? and m.override_attributes["redBorder"]["sensor_uuid"] == m.override_attributes["redBorder"]["organization_uuid"]
          organizations << m
        end
      end
      return organizations

    end
  end
end
