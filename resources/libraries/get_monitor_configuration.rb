module RbManager
  module Helpers
    def get_monitor_configuration
      monitor_config = []
      sensor = search(:node, 'redborder_monitors:[* TO *] AND name:*device*').sort
      sensor.each do |node|
        monitors = node.normal['redborder']['monitors']
        monitors.each do |monitor|
          if monitor['name'] == 'bulkstats_schema' || monitor['name'] == 'thermal'
            monitor_config << monitor['name']
          end
        end
      end
      monitor_config
    end
  end
end
