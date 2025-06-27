module RbManager
  module Helpers
  # The purpose of this helper is to control which nodes have erchef running. If not valid,
  # should not to be aimed by chef-client running
    def is_erchef_valid_host node
      return false unless node['redborder']['cdomain'] 
      erchef_services = node.dig('cluster', 'services')
      return false unless erchef_services
      opscode_erchef_property = erchef_services.find { |h| h['name'] == 'opscode-erchef' }
      opscode_erchef_property['ok']
    end
  end
end
