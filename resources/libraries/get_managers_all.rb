module RbManager
  module Helpers
    def get_managers_all
      managers = []
      managers_keys = Chef::Node.list.keys.sort
      managers_keys.each do |m_key|
        m = Chef::Node.load m_key
        m = node if m.name == node.name
<<<<<<< HEAD
        if m.role?("manager")
          managers << m
        end  
=======
        begin
          roles = m.roles
        rescue NoMethodError
          begin
            roles = m.run_list
          rescue
            roles = []
          end
        end
        next unless roles.nil?

        next unless roles.include?('manager')

        managers << m
>>>>>>> development
      end

      managers
    end
  end
end
