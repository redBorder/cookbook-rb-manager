module RbManager
  module Helpers
    def get_namespaces
      namespaces = []
      Chef::Role.list.each_key do |rol|
        ro = nil
        begin
          ro = Chef::Role.load rol
        rescue
          Chef::Log.error("[get_namespaces] Failed to load role: #{role}")
        end

        next unless ro && ro.override_attributes['redborder'] && ro.override_attributes['redborder']['namespace'] && ro.override_attributes['redborder']['namespace_uuid'] && !ro.override_attributes['redborder']['namespace_uuid'].empty?

        namespaces.push(ro.override_attributes['redborder']['namespace_uuid'])
      end

      namespaces.uniq
    end
  end
end
