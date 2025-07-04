require 'time'

module RbManager
  module Helpers
    def get_uptime
        begin
            boot_time_str = `uptime -s`.strip
            boot_time = Time.parse(boot_time_str)
            now = Time.now
            seconds = (now - boot_time).to_i
            time_units = {
                'year'   => 365 * 24 * 60 * 60,
                'month'  => 30 * 24 * 60 * 60,
                'week'   => 7 * 24 * 60 * 60,
                'day'    => 24 * 60 * 60,
                'hour'   => 60 * 60,
                'minute' => 60,
            }

            uptime_string = '< 1 minute'

            time_units.each do |name, unit_seconds|
                value = seconds / unit_seconds
                if value > 0
                uptime_string = "#{value} #{name}#{'s' if value != 1}"
                break
                end
            end

            uptime_string
        rescue => e
            Chef::Log.error("Error calculating uptime: #{e.message}")
            'N/A'
        end
    end
  end
end
