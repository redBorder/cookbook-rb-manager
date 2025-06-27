module RbManager
  module Helpers
  # The purpose of this helper is to control which nodes have erchef running. If not valid,
  # should not to be aimed by chef-client running
    def is_erchef_valid_host node
      puts 88888888888888888888888888
      return false unless node['redborder']['cdomain'] 
      puts 00000000000000000000
      erchef_services = node.dig('cluster', 'services')
      puts 11111111111111111111
      return false unless erchef_services
      puts 89999999999999999999999999999999999
      opscode_erchef_property = erchef_services.find { |h| h['name'] == 'opscode-erchef' }
      puts 4444444444444444444444444444444444
      opscode_erchef_property['ok']
    end
  end
end
