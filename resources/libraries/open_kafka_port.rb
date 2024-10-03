module RbManager
  module Helpers
    def interfaces
      init_conf = YAML.load_file('/etc/redborder/rb_init_conf.yml')
      init_conf['network']['interfaces']
    end

    def get_ip_of_manager_ips
      # IPS in manager mode has the role ips-sensor
      sensors = search(:node, "role:ips-sensor AND -redborder_parent_id:*?").sort
      sensors.map { |s| { ipaddress: s['ipaddress'] } }
    end

    def rule_exists?(rule)
      command = "firewall-cmd --zone=public --query-rich-rule='rule family=\"ipv4\" #{rule}' > /dev/null 2>&1"
      system(command)
    end

    def get_existing_ips_for_port
      existing_ips = []
      list_firewall_rules = `firewall-cmd --zone=public --list-rich-rules`
      list_firewall_rules.split("\n").each do |rule|
        if rule.include?('port="9092"')
          ip_match = rule.match(/source address="([^"]+)"/)
          existing_ips << ip_match[1] if ip_match
        end
      end
      existing_ips
    end

    def open_ports_for_ips
      return unless interfaces.count > 1
      manager_ips = get_ip_of_manager_ips
      existing_ips = get_existing_ips_for_port
      reload_needed = false

      if manager_ips.empty?
        existing_ips.each do |ip|
          remove_command = "firewall-cmd --zone=public --remove-rich-rule='rule family=\"ipv4\" source address=#{ip} port port=9092 protocol=tcp accept' --permanent"
          if rule_exists?("source address=#{ip} port port=9092 protocol=tcp accept")
            system(remove_command)
            reload_needed = true
          end
        end
      else
        # Remove IPs that are no longer needed
        ips_to_remove = existing_ips - manager_ips.map { |ips| ips[:ipaddress] }
        ips_to_remove.each do |ip|
          remove_command = "firewall-cmd --zone=public --remove-rich-rule='rule family=\"ipv4\" source address=#{ip} port port=9092 protocol=tcp accept' --permanent"
          if rule_exists?("source address=#{ip} port port=9092 protocol=tcp accept")
            system(remove_command)
            reload_needed = true
          end
        end

        manager_ips.each do |ips|
          ip_address = ips[:ipaddress]
          add_command = "firewall-cmd --zone=public --add-rich-rule='rule family=\"ipv4\" source address=#{ip_address} port port=9092 protocol=tcp accept' --permanent"
          unless rule_exists?("source address=#{ip_address} port port=9092 protocol=tcp accept")
            system(add_command)
            reload_needed = true
          end
        end
      end
      system("firewall-cmd --reload") if reload_needed
    end
  end
end
