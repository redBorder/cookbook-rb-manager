module RbManager
  module Helpers
    def get_managers_all
      managers = search(:node, 'role:manager').map { |m| m.name == node.name ? node : m }
      # The current node could not be indexed yet in the first execution
      managers << node if node.role?('manager') && !managers.include?(node)
      managers.sort
    end
  end
end
