module RbManager
  module Helpers
    def should_be_consul_server?
      consul_managers = node['redborder']['managers_per_services']['consul']
      hostname = node['hostname']
      total = consul_managers.size

      return true if total == 1

      desired_count = if total.odd?
                        total
                      else
                        total - 1
                      end

      consul_managers.take(desired_count).include?(hostname)
    end
  end
end
